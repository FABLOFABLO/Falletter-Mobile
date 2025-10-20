String formatTime(DateTime datetime) {
  final Duration diff = DateTime.now().difference(datetime);

  if (diff.inDays >= 365) {
    final years = (diff.inDays / 365).floor();
    return '$years년 전';
  } else if (diff.inDays >= 30) {
    final months = (diff.inDays / 30).floor();
    return '$months개월 전';
  } else if (diff.inDays >= 1) {
    return '${diff.inDays}일 전';
  } else if (diff.inHours >= 1) {
    return '${diff.inHours}시간 전';
  } else if (diff.inMinutes >= 1) {
    return '${diff.inMinutes}분 전';
  } else {
    return '방금 전';
  }
}