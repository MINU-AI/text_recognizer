import 'package:flutter_test/flutter_test.dart';
import 'package:recognition_text/recognition_text_platform_interface.dart';
import 'package:recognition_text/recognition_text_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockRecognitionTextPlatform
    with MockPlatformInterfaceMixin
    implements RecognitionTextPlatform {

  @override
  Future<String?> regconizeText({ required String imageSource, List<String>? languageCodes }) => Future.value("Test");
}

void main() {
  final RecognitionTextPlatform initialPlatform = RecognitionTextPlatform.instance;

  test('$MethodChannelRecognitionText is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelRecognitionText>());
  });

  test('getPlatformVersion', () async {
   
  });
}
