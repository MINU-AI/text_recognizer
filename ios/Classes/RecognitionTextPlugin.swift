import Flutter
import UIKit
import Vision
import PhotosUI

public class RecognitionTextPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "recognition_text", binaryMessenger: registrar.messenger())
    let instance = RecognitionTextPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
    
  var resultCallback: FlutterResult?
  var langageCodes: [String]?

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as! [String: Any]
    let languageCodes = arguments["languageCodes"] as? [String]
    let imageSource = ImagePickerSource(arguments["image_source"] as! String)
    print("Got native params: \(languageCodes ?? []), \(imageSource)")
      
    switch call.method {
    case "regconizeText":
        resultCallback = result
        self.langageCodes = languageCodes
        showPHPicker(source: imageSource)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

extension RecognitionTextPlugin: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            recognizeText(image: selectedImage, languageCodes: langageCodes) { recognizedString, error in
                guard error == nil else {
                    self.resultCallback?(error!)
                    self.resultCallback = nil
                    self.langageCodes = nil
                    return
                }
                self.resultCallback?(recognizedString)
                self.resultCallback = nil
                self.langageCodes = nil
            }
        } else {
            resultCallback = nil
            langageCodes = nil
        }
        
        picker.dismiss(animated: true, completion: nil) // Dismiss the picker
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil) // Dismiss the picker if canceled
    }
    
    private func showPHPicker(source: ImagePickerSource = .photoLibrary) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source == .photoLibrary ? .photoLibrary : .camera // Or .camera for capturing photos
        imagePicker.allowsEditing = true // Allow basic editing like cropping

        UIApplication.shared.delegate?.window??.rootViewController?.present(imagePicker, animated: true)
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

enum ImagePickerSource : String {
    case camera = "camera"
    case photoLibrary = "photoLibrary"
    
    init(_ rawValue: String) {
        switch rawValue {
        case "camera":
            self = .camera
        case "photoLibrary":
            self = .photoLibrary
        default:
            fatalError("Invalid ImagePickerSource")
        }
    }
}

