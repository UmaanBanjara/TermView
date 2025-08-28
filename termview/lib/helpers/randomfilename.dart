import 'dart:math';

String generateRandomFileName() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final rand = Random();
  String randomString = List.generate(8, (index) => chars[rand.nextInt(chars.length)]).join();
  return "thumbnail_$randomString.jpg";
}
