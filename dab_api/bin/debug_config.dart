import 'dart:io';
import 'package:dab_api/src/infrastructure/config/config.dart';

void main() {
  final config = Config();
  print('DAB_ALLOWED_DOMAIN: "${config.allowedDomain}"');
  print('DAB_INITIAL_ADMIN_EMAIL: "${config.initialAdminEmail}"');
  
  // Directly check if .env exists where we think it is
  final current = Directory.current.path;
  print('Current directory: $current');
  final envFile = File('$current/.env');
  print('.env exists in current: ${envFile.existsSync()}');
  
  if (envFile.existsSync()) {
    print('Content of .env:');
    print(envFile.readAsStringSync());
  }
}
