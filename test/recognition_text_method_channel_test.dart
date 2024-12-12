import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recognition_text/recognition_text_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelRecognitionText platform = MethodChannelRecognitionText();
  const MethodChannel channel = MethodChannel('recognition_text');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

}
