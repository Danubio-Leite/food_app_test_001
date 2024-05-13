import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'locks.env')
abstract class Env {
  @EnviedField(varName: 'gpt_key', obfuscate: true)
  static final String gpt_key = _Env.gpt_key;
}
