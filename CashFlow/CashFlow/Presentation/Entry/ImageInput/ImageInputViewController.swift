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


struct Item: Decodable {
    var id: String
    var name: String
    var category: String
    var price: Int

    // Define las claves de codificación que usarás en el proceso de decodificación.
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case price
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Nombre no disponible"
        category = try container.decodeIfPresent(String.self, forKey: .category) ?? "Categoría no disponible"
        price = try container.decodeIfPresent(Int.self, forKey: .price) ?? 0
    }

}

struct LineInfo {
    var text: String
    var cornerPoints: [CGPoint]
}

struct ApiResponse: Decodable {
    var details: [Item]

    enum CodingKeys: String, CodingKey {
        case details
    }

    // Tu método de inicialización personalizado
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        details = try container.decodeIfPresent([Item].self, forKey: .details) ?? []
    }
}



@objc(ImageInputViewController)
class ImageInputViewController: UIViewController, UINavigationControllerDelegate {
    
    var resultsText = ""
    
    private lazy var annotationOverlayView: UIView = {
      precondition(isViewLoaded)
      let annotationOverlayView = UIView(frame: .zero)
      annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
      annotationOverlayView.clipsToBounds = true
      return annotationOverlayView
    }()
    
    var imagePicker = UIImagePickerController()
    var currentImage = 0
    var activityIndicator: UIActivityIndicatorView!
    var containerView: UIView!


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
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .red
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
        activityIndicator.center = view.center

        view.addSubview(activityIndicator)
        
        // Inicializar la vista de contenedor
        containerView = UIView()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.6) // para semitransparencia
        containerView.layer.cornerRadius = 10 // para bordes redondeados

        // Asegúrate de que la vista de contenedor sea del tamaño que desees
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        // Agregar restricciones para la vista de contenedor
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 200).isActive = true // ajusta como desees
        containerView.heightAnchor.constraint(equalToConstant: 100).isActive = true // ajusta como desees

        // Inicializar el activity indicator
        activityIndicator = UIActivityIndicatorView(style: .large) // el estilo 'large' es más grande
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white // elige el color que desees

        // Agregar el activity indicator a la vista de contenedor
        containerView.addSubview(activityIndicator)

        // Agregar restricciones para el activity indicator
        activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true // ajusta el 'constant' como desees

        // Inicializar la etiqueta
        let label = UILabel()
        label.text = "Estamos analizando..."
        label.textColor = .white // elige el color que desees
        label.translatesAutoresizingMaskIntoConstraints = false

        // Agregar la etiqueta a la vista de contenedor
        containerView.addSubview(label)

        // Agregar restricciones para la etiqueta
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 20).isActive = true // ajusta el 'constant' como desees

        // Asegurarte de que la vista de contenedor esté oculta inicialmente
        containerView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    func showLoadingIndicator() {
        containerView.isHidden = false
        activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        containerView.isHidden = true
        activityIndicator.stopAnimating()
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
            let textProcessor = TextProcessor()
            weak var weakSelf = self
            textRecognizer?.process(visionImage) { text, error in
                guard let strongSelf = weakSelf else {
                    print("Self is nil!")
                    return
                }
                guard error == nil, let text = text else {
                    // Manejar errores aquí si el reconocimiento de texto falla.
                    let errorString = error?.localizedDescription ?? Constants.detectionNoResultsMessage
                    strongSelf.resultsText = "Text recognizer failed with error: \(errorString)"
                    strongSelf.showResults()  // Muestra los resultados aquí si hay un error.
                    return
                }
                // ... [código para procesar el texto reconocido] ...
                var linesInfo: [LineInfo] = []

                for block in text.blocks {
                    for line in block.lines {
                        // Convertir NSValue a CGPoint
                        let cornerPoints = line.cornerPoints.map { $0.cgPointValue }
                        let lineInfo = LineInfo(text: line.text, cornerPoints: cornerPoints)
                        linesInfo.append(lineInfo)
                    }
                }
                
                linesInfo.sort { $0.cornerPoints[0].y < $1.cornerPoints[0].y }

                let groupedLines = textProcessor.processRecognizedText(linesInfo: linesInfo)
                let finalTextLines = textProcessor.concatenateLines(from: groupedLines)
                
                var expense = textProcessor.createTotalExpense(finalTextLines: finalTextLines)
                
                // Envía la solicitud a tu servidor.
                lazy var apiURL: String = {
                    guard let apiURL = Bundle.main.object(forInfoDictionaryKey: "ChatgptApiURL") as? String else {
                        fatalError("ChatgptApiURL must not be empty in plist")
                    }
                    return apiURL
                }()
                self.showLoadingIndicator()
                sendRequest(urlString: apiURL, textData: expense.ocrText!, vendor: expense.vendorName!) { response, error in
                    // Vuelve al hilo principal si estás actualizando la UI.
                    DispatchQueue.main.async {
                        self.hideLoadingIndicator()
                        if let error = error {
                            // Manejar errores aquí, por ejemplo, mostrar una alerta al usuario.
                            print("Error: \(error.localizedDescription)")
                            // Considera llamar a `showResults` aquí para indicar que hubo un error.
                            expense.category = ExpenseCategory.mercado
                            Expense.sampleData.append(expense)
                            strongSelf.resultsText = "Request: \(expense.ocrText ?? " ")"
                            strongSelf.showResults()
                            return
                        }

                        if let response = response {
                            // Procesa la respuesta aquí.
                            for item in response.details {
                                strongSelf.resultsText += ("ID: \(item.id), Nombre: \(item.name), Categoría: \(item.category), Precio: \(item.price)\n")
                            }
                            // Muestra los resultados después de procesar la respuesta.
                            strongSelf.showResults()
                            print("Ya debieron mostrarse")
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

func sendRequest(urlString: String, textData: String, vendor: String, completion: @escaping (ApiResponse?, Error?) -> Void) {
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
    request.httpBody = httpBody

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        // Manejar errores de la solicitud.
        if let error = error {
            print("Hay un error")
            completion(nil, error)
            return
        }

        // Verificar y decodificar la respuesta.
        guard let data = data else {
            completion(nil, nil)
            return
        }
        
        do {
            print("decodificando los datos")
            let decoder = JSONDecoder()
            let response = try decoder.decode(ApiResponse.self, from: data)
            var newExpenses: [Expense] = []
            for item in response.details {
                let expense = Expense.from(item: item, vendor: vendor)
                newExpenses.append(expense)
            }

            // Agrupa los gastos por categoría y suma sus precios.
            let groupedExpenses = Dictionary(grouping: newExpenses, by: { $0.category })
            var summarizedExpenses: [Expense] = []
            
            for (category, expenses) in groupedExpenses {
                let totalSum = expenses.reduce(0) { $0 + $1.total }
                
                // Crea un nuevo gasto que representa el total de la categoría.
                let summaryExpense = Expense(id: UUID(), total: totalSum, date: Date(), description: "Total para \(category.rawValue)", vendorName: vendor, category: category)
                summarizedExpenses.append(summaryExpense)
            }
            
            Expense.sampleData.append(contentsOf: summarizedExpenses)
            completion(response, nil)
        } catch let error {
            completion(nil, error)
        }
    }
    
    task.resume()
}
