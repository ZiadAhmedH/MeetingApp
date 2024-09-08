import 'package:envied/envied.dart';

/// {@template env}
/// Environment variables. Used to access environment variables in the app.
/// {@endtemplate}
@Envied(path: '.env', obfuscate: true)
abstract class Env {
  /// Zego app id secret.
  @EnviedField(varName: 'ZEGO_APP_ID', obfuscate: true)
  static get zegoAppId => Env.zegoAppId;

  /// Zego app sign key secret.
  @EnviedField(varName: 'ZEGO_APP_SIGN', obfuscate: true)
  static String zegoAppSign = Env.zegoAppSign;
}