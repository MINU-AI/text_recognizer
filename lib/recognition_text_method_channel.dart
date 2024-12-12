import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'recognition_text_platform_interface.dart';

/// An implementation of [RecognitionTextPlatform] that uses method channels.
class MethodChannelRecognitionText extends RecognitionTextPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('recognition_text');

  @override
  Future<String?> regconizeText({ required String imageSource, List<String>? languageCodes }) async {
    return await methodChannel.invokeMethod<String>('regconizeText', { "image_source" :  imageSource, "languageCodes": languageCodes });
  }

  
}
