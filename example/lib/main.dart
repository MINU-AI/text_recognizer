import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:recognition_text/recognition_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _recognitionTextPlugin = RecognitionText();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      final byteData = await rootBundle.load("assets/sample.HEIC");
      final imageBytes = byteData.buffer.asUint8List();
      
      final text = await _recognitionTextPlugin.regconizeText(imageBytes: imageBytes) ?? 'Unknown text recognized';
      print(text);
      final detectText = await _recognitionTextPlugin.detectText(imageBytes: imageBytes) ?? 'Unknown text recognized';
      print("\nDetect text: $detectText");

    } catch(e) { 
      print("Error: $e");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
   
  }

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Center(
        child: SizedBox()
      ),
    );
  }
}
