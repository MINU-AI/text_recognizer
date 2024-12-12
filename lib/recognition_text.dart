
import 'recognition_text_platform_interface.dart';

class RecognitionText {
  //Supported languages
  //["en-US", "fr-FR", "it-IT", "de-DE", "es-ES", "pt-BR", "zh-Hans", "zh-Hant", "yue-Hans", "yue-Hant", "ko-KR", "ja-JP", "ru-RU", "uk-UA"]
  Future<String?> regconizeText({ ImagePickerSource imageSource = ImagePickerSource.photoLibrary, List<String>? langageCodes }) {
    return RecognitionTextPlatform.instance.regconizeText(imageSource: imageSource.name, languageCodes: langageCodes );
  }
}

enum ImagePickerSource {
  camera, photoLibrary
}
