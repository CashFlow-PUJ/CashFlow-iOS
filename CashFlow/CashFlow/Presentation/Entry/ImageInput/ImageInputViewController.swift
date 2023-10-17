//
//  ImageInputViewController.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 14/09/23.
//

import UIKit
import MLImage
import MLKit
import Foundation
import SwiftUI


// Representa la información individual de un artículo.
struct Item: Decodable {
    var id: String
    var name: String
    var category: String
    var price: Int
}

// Representa la estructura completa de la respuesta con una lista de detalles.
struct ApiResponse: Decodable {
    var details: [Item]
}

@objc(ImageInputViewController)
class ImageInputViewController: UIViewController, UINavigationControllerDelegate {
    
    /// A string holding current results from detection.
    var resultsText = ""
    
    /// An overlay view that displays detection annotations.
    private lazy var annotationOverlayView: UIView = {
      precondition(isViewLoaded)
      let annotationOverlayView = UIView(frame: .zero)
      annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
      annotationOverlayView.clipsToBounds = true
      return annotationOverlayView
    }()
    
    /// An image picker for accessing the photo library or camera.
    var imagePicker = UIImagePickerController()
    
    // Image counter.
    var currentImage = 0
    
    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var imageView: UIImageView!
    
    // TODO: Change the following as they will not necessarily be a UIBarButtonItem (but necessarily a type of Button)
    @IBOutlet fileprivate weak var photoCameraButton: UIBarButtonItem!
    @IBOutlet weak var detectButton: UIBarButtonItem!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: Constants.images[currentImage])
        imageView.addSubview(annotationOverlayView)
        NSLayoutConstraint.activate([
            annotationOverlayView.topAnchor.constraint(equalTo: imageView.topAnchor),
            annotationOverlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            annotationOverlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            annotationOverlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
        ])
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        let isCameraAvailable =
        UIImagePickerController.isCameraDeviceAvailable(.front)
        || UIImagePickerController.isCameraDeviceAvailable(.rear)
        
        if !isCameraAvailable {
            photoCameraButton.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - IBActions
    
    @IBAction func detect(_ sender: Any) {
        clearResults()
        detectTextOnDevice(image: imageView.image)
    }
    
    @IBAction func openPhotoLibrary(_ sender: Any) {
      imagePicker.sourceType = .photoLibrary
      present(imagePicker, animated: true)
    }
    
    @IBAction func openCamera(_ sender: Any) {
        guard
            UIImagePickerController.isCameraDeviceAvailable(.front)
                || UIImagePickerController
                .isCameraDeviceAvailable(.rear)
        else {
            return
        }
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    @IBAction func downloadOrDeleteModel(_ sender: Any) {
      clearResults()
    }
    
    // MARK: - Private
    
    /// Removes the detection annotations from the annotation overlay view.
    private func removeDetectionAnnotations() {
      for annotationView in annotationOverlayView.subviews {
        annotationView.removeFromSuperview()
      }
    }
    
    /// Clears the results text view and removes any frames that are visible.
    private func clearResults() {
      removeDetectionAnnotations()
      self.resultsText = ""
    }
    
    private func showResults() {
        let resultsAlertController = UIAlertController(
            title: "Detection Results",
            message: nil,
            preferredStyle: .actionSheet
        )
        resultsAlertController.addAction(
            UIAlertAction(title: "OK", style: .destructive) { _ in
                resultsAlertController.dismiss(animated: true, completion: nil)
            }
        )
        resultsAlertController.message = resultsText
        // TODO: Find a way to replace the following functionality with the intended.
        resultsAlertController.popoverPresentationController?.barButtonItem = detectButton
        resultsAlertController.popoverPresentationController?.sourceView = self.view
        present(resultsAlertController, animated: true, completion: nil)
        print(resultsText)
    }
    
    /// Updates the image view with a scaled version of the given image.
    private func updateImageView(with image: UIImage) {
      let orientation = UIApplication.shared.statusBarOrientation
      var scaledImageWidth: CGFloat = 0.0
      var scaledImageHeight: CGFloat = 0.0
      switch orientation {
      case .portrait, .portraitUpsideDown, .unknown:
        scaledImageWidth = imageView.bounds.size.width
        scaledImageHeight = image.size.height * scaledImageWidth / image.size.width
      case .landscapeLeft, .landscapeRight:
        scaledImageWidth = image.size.width * scaledImageHeight / image.size.height
        scaledImageHeight = imageView.bounds.size.height
      @unknown default:
        fatalError()
      }
      weak var weakSelf = self
      DispatchQueue.global(qos: .userInitiated).async {
        // Scale image while maintaining aspect ratio so it displays better in the UIImageView.
        var scaledImage = image.scaledImage(
          with: CGSize(width: scaledImageWidth, height: scaledImageHeight)
        )
        scaledImage = scaledImage ?? image
        guard let finalImage = scaledImage else { return }
        DispatchQueue.main.async {
          weakSelf?.imageView.image = finalImage
        }
      }
    }
    
    private func detectTextOnDevice(image: UIImage?) {
        guard let image = image else { return }
        
        // [START init_text]
        let options: CommonTextRecognizerOptions = TextRecognizerOptions.init()
        
        let onDeviceTextRecognizer = TextRecognizer.textRecognizer(options: options)
        // [END init_text]
        
        // Initialize a `VisionImage` object with the given `UIImage`.
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        
        self.resultsText += "Running On-Device Text Recognition...\n"
        tgtgprocess(visionImage, with: onDeviceTextRecognizer)
    }
    
    private func tgtgprocess(_ visionImage: VisionImage, with textRecognizer: TextRecognizer?) {
        weak var weakSelf = self
        textRecognizer?.process(visionImage) { [self] text, error in
            guard let strongSelf = weakSelf else {
                print("Self is nil!")
                return
            }
            guard error == nil, let text = text else {
                let errorString = error?.localizedDescription ?? Constants.detectionNoResultsMessage
                strongSelf.resultsText = "Text recognizer failed with error: \(errorString)"
                strongSelf.showResults()
                return
            }
            // Blocks.
            for block in text.blocks {
                let transformedRect = block.frame.applying(strongSelf.transformMatrix())
                UIUtilities.addRectangle(
                    transformedRect,
                    to: strongSelf.annotationOverlayView,
                    color: UIColor.purple
                )
                
                // Lines.
                for line in block.lines {
                    let transformedRect = line.frame.applying(strongSelf.transformMatrix())
                    UIUtilities.addRectangle(
                        transformedRect,
                        to: strongSelf.annotationOverlayView,
                        color: UIColor.orange
                    )
                    
                    // Elements.
                    for element in line.elements {
                        let transformedRect = element.frame.applying(strongSelf.transformMatrix())
                        UIUtilities.addRectangle(
                            transformedRect,
                            to: strongSelf.annotationOverlayView,
                            color: UIColor.green
                        )
                        let label = UILabel(frame: transformedRect)
                        label.text = element.text
                        label.adjustsFontSizeToFitWidth = true
                        strongSelf.annotationOverlayView.addSubview(label)
                    }
                }
            }
            
            let apiURL = "https://us-central1-white-library-365314.cloudfunctions.net/extractada"
            let token = "0NzA4MDU0LTlyOXMxYzRhbGczNmVybGl1Y2hvOXQ1Mm4zMm42ZGdxLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiYXVkIjoiNjE4MTA0NzA4MDU0LTlyOXMxYzRhbGczNmVybGl1Y2hvOXQ1Mm4zMm42ZGdxLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTEyMTYyMjMwMDM0MTk0NTg2NDE1IiwiZW1haWwiOiJhdHBlbmFwZW5hQGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdF9oYXNoIjoiWWdxajRvVGJNLV9vNnR5WVRPZ0NUZyIsIm5iZiI6MTY5NzU1NzUxNCwiaWF0IjoxNjk3NTU3ODE0LCJleHAiOjE2OTc1NjE0MTQsImp0aSI6ImNjNzMxZWU5MGEzMjI2OWZhOWM2OTY2ZTcyYzZiMGQ5YTM5OTUyOGEifQ.f7Rr5bOU-fEv4QIcWH9U0rYEXf4rfwLe5ooXdoaFOX0RDG5oMLSXzBWcV7H-7OzsXUlUe-FoaGxGGsNn_-hng26ChmUFdE2mlmoOXM393UTl3XP-XkKo-AnFO9WWTnLRrvskC42BWg_oGclX5Wu8HM7GRGVFpHFmYe168a-lp2LOdYIDFixbr173o9ndF6ryXofbyDRkfkquD9i6eUBnDy79BDltHgZfeiN5Ve3iosAX9Z_T2qvjIPslkVpz03vficnp1R5VR87QMROF5XQTBEc-TXgoCe09wi25akfNTjcEayLXT19jS4hMcp0mY7tb45Nymf6lIH5DHL6UPdHR6A"
            
            sendRequest(urlString: apiURL, token: token, textData: text.text) { response, error in
                if let error = error {
                    // Manejar errores aquí.
                    print("Error: \(error.localizedDescription)")
                    return
                }

                if let response = response {
                    // Procesar respuesta aquí.
                    for item in response.details {
                        strongSelf.resultsText +=  ("ID: \(item.id), Nombre: \(item.name), Categoría: \(item.category), Precio: \(item.price)")
                        strongSelf.showResults()
                    }
                }
            }
            
        }
    }
    
    private func transformMatrix() -> CGAffineTransform {
        
        // TODO: Find a way to link imageView in parent View (ImageInputView - SwiftUI).
        
        guard let image = imageView.image else { return CGAffineTransform() }
        let imageViewWidth = imageView.frame.size.width
        let imageViewHeight = imageView.frame.size.height
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        let imageViewAspectRatio = imageViewWidth / imageViewHeight
        let imageAspectRatio = imageWidth / imageHeight
        let scale =
        (imageViewAspectRatio > imageAspectRatio)
        ? imageViewHeight / imageHeight : imageViewWidth / imageWidth
        
        // Image view's `contentMode` is `scaleAspectFit`, which scales the image to fit the size of the
        // image view by maintaining the aspect ratio. Multiple by `scale` to get image's original size.
        let scaledImageWidth = imageWidth * scale
        let scaledImageHeight = imageHeight * scale
        let xValue = (imageViewWidth - scaledImageWidth) / CGFloat(2.0)
        let yValue = (imageViewHeight - scaledImageHeight) / CGFloat(2.0)
        
        var transform = CGAffineTransform.identity.translatedBy(x: xValue, y: yValue)
        transform = transform.scaledBy(x: scale, y: scale)
        return transform
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ImageInputViewController: UIImagePickerControllerDelegate {

  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    // Local variable inserted by Swift 4.2 migrator.
    let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

    clearResults()
    if let pickedImage =
      info[
        convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]
      as? UIImage
    {
      updateImageView(with: pickedImage)
    }
    dismiss(animated: true)
  }
}

// MARK: - Enums

private enum Constants {
    
    // TODO: Change the following file with a coherent Placeholder image.
    static let images = [
      "image_has_text.jpg",
    ]
    
    static let detectionNoResultsMessage = "No results returned."
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKeyDictionary(
  _ input: [UIImagePickerController.InfoKey: Any]
) -> [String: Any] {
  return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey)
  -> String
{
  return input.rawValue
}

func sendRequest(urlString: String, token: String, textData: String, completion: @escaping (ApiResponse?, Error?) -> Void) {
    guard let url = URL(string: urlString) else {
        print("Error: cannot create URL")
        completion(nil, nil)
        return
    }

    // Crear un diccionario para los datos de tu solicitud.
    let requestBody: [String: Any] = ["data": textData]
    
    // Convertir el diccionario en datos JSON.
    guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
        print("Error: Something went wrong with JSON data")
        completion(nil, nil)
        return
    }

    // Crear una solicitud URL y configurarla con los datos JSON y el token de autorización.
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.httpBody = httpBody

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        // Manejar errores de la solicitud.
        if let error = error {
            completion(nil, error)
            return
        }

        // Verificar y decodificar la respuesta.
        guard let data = data else {
            completion(nil, nil)
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(ApiResponse.self, from: data)
            completion(response, nil)
        } catch let error {
            completion(nil, error)
        }
    }
    
    task.resume()
}
