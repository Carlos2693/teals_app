import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String firebaseKey = dotenv.env['FIREBASE_KEY'] ?? 'Not name';
}
