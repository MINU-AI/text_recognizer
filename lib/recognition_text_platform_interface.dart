import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'recognition_text_method_channel.dart';

abstract class RecognitionTextPlatform extends PlatformInterface {
  /// Constructs a RecognitionTextPlatform.
  RecognitionTextPlatform() : super(token: _token);

  static final Object _token = Object();

  static RecognitionTextPlatform _instance = MethodChannelRecognitionText();

  /// The default instance of [RecognitionTextPlatform] to use.
  ///
  /// Defaults to [MethodChannelRecognitionText].
  static RecognitionTextPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RecognitionTextPlatform] when
  /// they register themselves.
  static set instance(RecognitionTextPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> regconizeText({ required String imageSource, List<String>? languageCodes }) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
