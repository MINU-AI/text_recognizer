import Flutter
import UIKit
import Vision

public class RecognitionTextPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "recognition_text", binaryMessenger: registrar.messenger())
    let instance = RecognitionTextPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
    
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as! [String: Any]
          
    switch call.method {
    case "regconizeText":
        let languageCodes = arguments["languageCodes"] as? [String]
        let imageBytes = arguments["imageBytes"] as! FlutterStandardTypedData
        print("Got native params: \(languageCodes ?? []), \(imageBytes)")
        let image = UIImage(data: imageBytes.data)!
        recognizeText(image: image) { recognizedText, error in
            guard error == nil else {
                result(error!)
                return
            }
            result(recognizedText!)
        }
        
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

extension RecognitionTextPlugin {
    func recognizeText(image: UIImage, languageCodes: [String]? = nil, completion: @escaping ((String?, FlutterError?) -> Void)) {
        // Get the CGImage on which to perform requests.
        guard let cgImage = image.cgImage else {
            completion(nil, FlutterError(code: "", message: "Text recognition failed: input image is nil", details: nil))
            return
        }

        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        // Create a new request to recognize text.
        let request = VNRecognizeTextRequest { request, error in
            guard error == nil else {
                completion(nil, FlutterError(code: "", message: "Text recognition failed: \(error!.localizedDescription)", details: nil))
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(nil, FlutterError(code: "", message: "Text recognition failed: got nil observations", details: nil))
                return
            }
            
            guard !observations.isEmpty else {
                completion(nil, FlutterError(code: "", message: "Text recognition failed: got empty observations", details: nil))
                return
            }
            
            var recognizedString = ""
            for observation in observations {
                // Return the string of the top VNRecognizedText instance.
                if let candidateString = observation.topCandidates(1).first?.string {
                    recognizedString += "\(candidateString)\n"
                }
            }
            
            completion(recognizedString.trimmingCharacters(in: .whitespacesAndNewlines), nil)
        }
        request.recognitionLevel = .accurate
        if #available(iOS 16.0, *) {
            request.automaticallyDetectsLanguage = true
        }
        
        if let languageCodes = languageCodes {
            request.recognitionLanguages = languageCodes
        }

//        let languages = try? request.supportedRecognitionLanguages()
//        print("Languages: \(languages)")

        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
            completion(nil, FlutterError(code: "", message: "Text recognition failed: \(error.localizedDescription)", details: nil))
        }
    }
}


