

import 'package:flutter/foundation.dart';

import 'recognition_text_platform_interface.dart';

class RecognitionText {
  //Supported languages
  //["en-US", "fr-FR", "it-IT", "de-DE", "es-ES", "pt-BR", "zh-Hans", "zh-Hant", "yue-Hans", "yue-Hant", "ko-KR", "ja-JP", "ru-RU", "uk-UA"]
  Future<String?> regconizeText({ required Uint8List imageBytes,  List<String>? langageCodes }) {
    return RecognitionTextPlatform.instance.regconizeText(imageBytes: imageBytes, languageCodes: langageCodes );
  }

  Future<bool?> detectText({ required Uint8List imageBytes }) {
    return RecognitionTextPlatform.instance.detectText(imageBytes: imageBytes);
  }
}

enum ImagePickerSource {
  camera, photoLibrary
}
