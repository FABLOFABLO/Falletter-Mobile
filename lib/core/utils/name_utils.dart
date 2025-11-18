const firstList = ['ㄱ','ㄴ','ㄷ','ㄹ','ㅁ','ㅂ','ㅅ','ㅇ','ㅈ','ㅊ','ㅋ','ㅌ','ㅍ','ㅎ','ㄲ','ㄸ','ㅃ','ㅆ','ㅉ'];
const secondList = ['ㅏ','ㅐ','ㅑ','ㅒ','ㅓ','ㅔ','ㅕ','ㅖ','ㅗ','ㅘ','ㅙ','ㅚ','ㅛ','ㅜ','ㅝ','ㅞ','ㅟ','ㅠ','ㅡ','ㅢ','ㅣ'];
const lastList = ['', 'ㄱ','ㄲ','ㄳ','ㄴ','ㄵ','ㄶ','ㄷ','ㄹ','ㄺ','ㄻ','ㄼ','ㄽ','ㄾ','ㄿ','ㅀ','ㅁ','ㅂ','ㅄ','ㅅ','ㅆ','ㅇ','ㅈ','ㅊ','ㅋ','ㅌ','ㅍ','ㅎ'];

List<String> decomposeKoreanToJamo(String name) {
  List<String> result = [];

  for (var rune in name.runes) {
    int charCode = rune;

    // 한글 완성형 범위 체크
    if (charCode >= 0xAC00 && charCode <= 0xD7A3) {
      int uniVal = charCode - 0xAC00;

      int chosungIndex = uniVal ~/ (21 * 28);
      int jungsungIndex = (uniVal % (21 * 28)) ~/ 28;
      int jongsungIndex = uniVal % 28;

      result.add(firstList[chosungIndex]);      // 초성
      result.add(secondList[jungsungIndex]);    // 중성
      if (lastList[jongsungIndex].isNotEmpty) {
        result.add(lastList[jongsungIndex]);    // 종성
      }
    }
  }
  return result;
}
