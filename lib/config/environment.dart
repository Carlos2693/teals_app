import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String apiKey = dotenv.env['API_KEY'] ?? '';
  static String appId = dotenv.env['APP_ID'] ?? '';
  static String messagingSenderId = dotenv.env['MESSAGING_SENDER_ID'] ?? '';
  static String projectId = dotenv.env['PROJECT_ID'] ?? '';
  static String storageBucket = dotenv.env['STORAGE_BUCKET'] ?? '';
}