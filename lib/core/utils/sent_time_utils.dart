String formatSentTime(DateTime? sentTime) {


  if (sentTime == null) {
    return '전송 중...';
  }

  final now = DateTime.now();
  final difference = now.difference(sentTime);

  if (difference.inDays >= 7) {
    final month = sentTime.month.toString().padLeft(2, '0');
    final day = sentTime.day.toString().padLeft(2, '0');
    return '$month월 $day일에 도착함';
  }
  else if  (difference.inDays > 0) {
    return '${difference.inDays}일 전에 도착함';
  }
  else if (difference.inHours > 0) {
    return '${difference.inHours}시간 전에 도착함';
  }
  else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}분 전에 도착함';
  }
  else {
    return '방금 도착함';
  }
}