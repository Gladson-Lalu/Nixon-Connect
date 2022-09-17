String getTimeDifference(DateTime time) {
  String temp = '';
  final difference = DateTime.now().difference(time);
  if (difference.inDays > 0) {
    temp = '${difference.inDays}d ago';
  } else if (difference.inHours > 0) {
    temp = '${difference.inHours}h ago';
  } else if (difference.inMinutes > 0) {
    temp = '${difference.inMinutes}m ago';
  } else {
    temp = 'Now';
  }
  return temp;
}
