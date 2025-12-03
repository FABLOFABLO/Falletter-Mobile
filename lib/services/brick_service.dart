import 'package:dio/dio.dart';
import 'package:falletter/core/constants/api_endpoints.dart';
import 'package:falletter/models/brick_history_model.dart';
import 'package:falletter/services/dio.dart';

class BrickHistoryService {
  final String accessToken;
  final Dio _dio = DioClient().dio;

  BrickHistoryService(this.accessToken);

  Future<int> fetchBrickCount() async {
    try {
      final response = await _dio.get(
        ApiEndPoints.brickCount,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      if (response.statusCode != 200) {
        throw Exception("브릭 개수 조회 오류");
      }

      final data = response.data;
      if (data is Map && data.containsKey('count')) {
        return data['count'] as int;
      } else if (data is int) {
        return data;
      } else {
        return 0;
      }
    } on DioException catch (e) {
      throw Exception("브릭 개수 조회 오류: ${e.response?.statusCode}");
    }
  }

  Future<void> updateBrickCount({required int brickUpdate}) async {
    try {
      final response = await _dio.patch(
        ApiEndPoints.brickUpdate,
        data: {"brick_update": brickUpdate},
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      switch (response.statusCode) {
        case 200:
          return;
        case 400:
          throw Exception('잘못된 요청');
        case 401:
          throw Exception('인증 실패');
        case 404:
          throw Exception('유저 없음');
        default:
          throw Exception('서버 오류');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) throw Exception('잘못된 요청');
      if (e.response?.statusCode == 401) throw Exception('인증 실패');
      if (e.response?.statusCode == 404) throw Exception('유저 없음');
      throw Exception("서버 오류: ${e.response?.statusCode}");
    }
  }

  Future<void> createBrickHistory(BrickHistoryModel model) async {
    try {
      final response = await _dio.post(
        ApiEndPoints.brickSave,
        data: model.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode != 201) {
        throw Exception("오류: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception("오류: ${e.response?.statusCode}");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateBrickWithHistory({
    required int brickUpdate,
    required BrickHistoryModel historyModel,
  }) async {
    await updateBrickCount(brickUpdate: brickUpdate);
    await createBrickHistory(historyModel);
  }

  Future<List<BrickHistoryResponseModel>> fetchHistory() async {
    try {
      final response = await _dio.get(
        ApiEndPoints.brickUsed,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception("오류 발생: ${response.statusCode}");
      }

      if (response.data == null) {
        return [];
      }

      if (response.data is! List) {
        if (response.data is Map) {
          final map = response.data as Map<String, dynamic>;

          if (map.containsKey('data') && map['data'] is List) {
            final dataList = map['data'] as List;
            return _parseHistoryList(dataList);
          }
        }

        throw Exception("예상하지 못한 응답 형식");
      }

      final data = response.data as List;
      if (data.isEmpty) {
        return [];
      }

      return _parseHistoryList(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception("오류: ${e.response?.statusCode ?? 'Network Error'}");
    } catch (e) {
      rethrow;
    }
  }

  List<BrickHistoryResponseModel> _parseHistoryList(List data) {
    final list = <BrickHistoryResponseModel>[];
    for (int i = 0; i < data.length; i++) {
      try {
        final model = BrickHistoryResponseModel.fromJson(data[i]);
        list.add(model);
      } catch (e) {
        rethrow;
      }
    }
    return list;
  }
}
