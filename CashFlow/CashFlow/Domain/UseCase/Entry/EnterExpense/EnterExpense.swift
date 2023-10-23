//
//  EnterExpense.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 27/09/23.
//

import Foundation
import MLKit

class TextProcessor {
    // Hacer la función 'public' o asegurarse de que tenga el nivel de acceso correcto para ser llamada desde otros archivos.
    public func processRecognizedText(linesInfo: [LineInfo]) -> [[LineInfo]] {
        
        let threshold: CGFloat = 10.0
        var groupedLines: [[LineInfo]] = []
        var currentGroup: [LineInfo] = []
        
        for i in 0..<linesInfo.count {
            if currentGroup.isEmpty {
                currentGroup.append(linesInfo[i])
            } else if abs(currentGroup.last!.cornerPoints[0].y - linesInfo[i].cornerPoints[0].y) < threshold {
                
                currentGroup.append(linesInfo[i])
            } else {
                groupedLines.append(currentGroup)
                currentGroup = [linesInfo[i]]
            }
        }
        
        // Asegúrate de agregar el último grupo si no está vacío.
        if !currentGroup.isEmpty {
            groupedLines.append(currentGroup)
        }
        return groupedLines
    }
    
    func concatenateLines(from groupedLines: [[LineInfo]]) -> [String] {
        var concatenatedLines = [String]()

        for lineGroup in groupedLines {
            // Concatenar el texto de todas las líneas en el mismo grupo.
            let groupedText = lineGroup.map { $0.text }.joined(separator: " ")
            concatenatedLines.append(groupedText)
        }

        return concatenatedLines
    }
    
    func createTotalExpense(finalTextLines: [String]) -> Expense{
        var myExpense = Expense(
            id: UUID(),
            total: getTotal(vendorName: getBusinessName(finalTextLines: finalTextLines),finalTextLines: finalTextLines),
            date: Date(),
            description: nil,
            vendorName: getBusinessName(finalTextLines: finalTextLines),
            category: .total,
            ocrText: getOCRbyVendor(vendorName: getBusinessName(finalTextLines: finalTextLines), finalTextLines: finalTextLines)
        )
        return myExpense
    }
    
    func getBusinessName(finalTextLines: [String]) -> String {
        var extractedName: String?
        
        for line in finalTextLines {
            if let range = line.range(of: "S.A.S", options: .caseInsensitive) {
                extractedName = String(line[..<range.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
            } else if let range = line.range(of: "S.A", options: .caseInsensitive) {
                extractedName = String(line[..<range.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        if let name = extractedName {
            return name
        } else {
            return ""
        }
    }
    
    func getMaxSubtotal(from textLines: [String]) -> Double {
        var highestSubtotal: Double = 0.0
        
        // Expresión regular para identificar valores numéricos con decimales,
        // considerando puntos y espacios en los números.
        let numberPattern = "\\d{1,3}(?:[.,]\\d{3})*(?:[.,]\\d{2})?"
        
        // Iterar sobre todas las líneas del texto.
        for line in textLines {
            // Verificar si la línea contiene "SUBTOTAL/TOTAL".
            if line.contains("SUBTOTAL/TOTAL") {
                // Buscar todos los números en la línea.
                let regex = try? NSRegularExpression(pattern: numberPattern)
                let nsrange = NSRange(line.startIndex..<line.endIndex, in: line)
                let matches = regex?.matches(in: line, options: [], range: nsrange) ?? []
                
                for match in matches {
                    let matchRange = Range(match.range, in: line)!
                    let matchString = line[matchRange]
                    
                    // Limpiar la cadena numérica y prepararla para la conversión.
                    var cleanNumberString = String(matchString)
                        .replacingOccurrences(of: ".", with: "") // Remueve puntos si están usados para separar miles.
                        .replacingOccurrences(of: ",", with: ".") // Considera las comas como indicadores decimales.
                        .replacingOccurrences(of: " ", with: "") // Remueve espacios.
                    
                    let digitCount = cleanNumberString.filter { $0.isNumber }.count
                    if digitCount < 4 {
                        cleanNumberString += "000"
                    }
                    // Convertir la cadena limpiada a un número flotante y verificar si es mayor que el subtotal más alto actual.
                    if let number = Double(cleanNumberString), number > highestSubtotal {
                        highestSubtotal = number
                    }
                }
            }
        }
        
        return highestSubtotal
    }

    
    func getTotal(vendorName: String, finalTextLines: [String]) -> Int {
        var total: Int = 0
        var foundValue: Bool = false // Esta bandera verifica si hemos encontrado algún valor
        
        if vendorName == "Almacenes Exito" {
            return Int(getMaxSubtotal(from: finalTextLines))
        }
        
        // Primero, intentamos encontrar "Valor Pagado".
        for line in finalTextLines {
            if let valorRange = line.range(of: "Valor Pagado", options: .caseInsensitive) {
                let numberSubstring = line[valorRange.upperBound...]
                let cleanNumberString = numberSubstring
                            .replacingOccurrences(of: ".", with: "") // Elimina puntos
                            .replacingOccurrences(of: " ", with: "") // Elimina espacios
                
                if let number = Int(cleanNumberString) {
                    total = number
                    foundValue = true // Marcamos que hemos encontrado un valor
                    break // Salimos del ciclo porque hemos encontrado lo que necesitábamos
                }
            }
        }

        // Si no encontramos "Valor Pagado", buscamos "TOTAL".
        if !foundValue {
            for line in finalTextLines {
                if line.range(of: "TOTAL", options: .caseInsensitive) != nil {
                    // La línea contiene "TOTAL", por lo que buscamos cualquier número en ella.
                    // Creamos una expresión regular para identificar los números en la línea.
                    let pattern = "\\d{1,3}(?:[.,]\\d{3})*(?:[.,]\\d{2})?"
                    let regex = try? NSRegularExpression(pattern: pattern)

                    let nsrange = NSRange(line.startIndex..<line.endIndex, in: line)
                    let matches = regex?.matches(in: line, options: [], range: nsrange) ?? []

                    for match in matches {
                        let matchRange = Range(match.range, in: line)!
                        let matchString = line[matchRange]

                        // Limpia y convierte el número encontrado.
                        var cleanNumberString = String(matchString)
                                    .replacingOccurrences(of: ".", with: "") // Si usas puntos para los decimales, no hagas esto.
                                    .replacingOccurrences(of: ",", with: "") // Remueve comas si están usadas para separar miles.
                                    .replacingOccurrences(of: " ", with: "") // Remueve espacios.
                        
                        cleanNumberString += "000"
                        
                        if let number = Int(cleanNumberString) {
                            total = number
                            foundValue = true // Marcamos que hemos encontrado un valor
                            break // Salimos del ciclo porque hemos encontrado lo que necesitábamos
                        }
                    }

                    // Si encontramos un total, no necesitamos seguir buscando en las otras líneas.
                    if foundValue {
                        break
                    }
                }
            }
        }
        
        return total
    }
    
    func getOCRProcessExito (finalTextLines: [String]) -> String {
        
        var isRecording = false
        var processedLines: [String] = []
        var skipNextLine = false
        
        for i in 0..<finalTextLines.count {
            if skipNextLine {
                skipNextLine = false
                continue
            }

            let line = finalTextLines[i]
            if line.contains("SUBTOTAL/TOTAL"){
                continue
            }
            if line.contains("CL SI FA NO") {
                isRecording = true
            }

            if isRecording {
                let transformed = line
                let currentLine = replaceLetterOWithZero(in: transformed)
                
                // División basada en la presencia de múltiples códigos de productos en la misma línea.
                let productCodes = getProductCodes(currentLine: currentLine)

                if productCodes.count > 1 {
                    // Si encontramos múltiples códigos de producto, dividimos la línea.
                    var previousRange: Range<String.Index>? = nil
                    for code in productCodes {
                        if let range = currentLine.range(of: code) {
                            if let prevRange = previousRange {
                                // Extraemos el texto desde el final del código anterior hasta el comienzo del código actual.
                                let productInfoRange = prevRange.upperBound..<range.lowerBound
                                let productInfo = currentLine[productInfoRange].trimmingCharacters(in: .whitespacesAndNewlines)
                                
                                // Construimos la línea completa para este producto, incluyendo el código anterior y la información del producto.
                                let fullProductLine = currentLine[prevRange] + " " + productInfo
                                
                                if !fullProductLine.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    processedLines.append(String(fullProductLine))
                                }
                            }
                            previousRange = range
                        }
                    }
                    // Tratar el último producto de la línea, si existe, después del último código.
                    if let lastRange = previousRange {
                        let lastProductInfo = currentLine[lastRange.upperBound...].trimmingCharacters(in: .whitespacesAndNewlines)
                        if !lastProductInfo.isEmpty {
                            // Para el último segmento, incluimos el último código de producto y su descripción correspondiente.
                            let lastFullProductLine = currentLine[lastRange] + " " + lastProductInfo
                            processedLines.append(String(lastFullProductLine))
                        }
                    }
                }else {
                    // Si no hay necesidad de dividir, procesamos normalmente.
                    if line.range(of: "X \\$[0-9,]+", options: .regularExpression) != nil && i + 1 < finalTextLines.count {
                        let nextLine = finalTextLines[i + 1]
                        let combinedLine = "\(line) \(nextLine)"
                        processedLines.append(combinedLine)
                        skipNextLine = true
                    } else {
                        processedLines.append(currentLine)
                    }
                }
                
                if line.contains("CAMBI") {
                    break
                }
            }
        }
        // Filtramos las líneas procesadas para eliminar aquellas que puedan ser ruido o irrelevantes.
        let meaningfulLines = processedLines.filter { line in
            let words = line.split(whereSeparator: { $0.isWhitespace })
            return words.count >= 2
        }

        return meaningfulLines.joined(separator: "\n")
    }
    
    func getOCRProcess (finalTextLines: [String]) -> String {
        
        var isRecording = false
        var processedLines: [String] = []
        var skipNextLine = false
        
        for i in 0..<finalTextLines.count {
            if skipNextLine {
                skipNextLine = false
                continue
            }

            let line = finalTextLines[i]

            if line.contains("VALOR") {
                isRecording = true
            }

            if isRecording {
                let transformed = line
                let currentLine = replaceLetterOWithZero(in: transformed)
                
                // División basada en la presencia de múltiples códigos de productos en la misma línea.
                let productCodes = getProductCodes(currentLine: currentLine)

                if productCodes.count > 1 {
                    // Si encontramos múltiples códigos de producto, dividimos la línea.
                    var previousRange: Range<String.Index>? = nil
                    for code in productCodes {
                        if let range = currentLine.range(of: code) {
                            if let prevRange = previousRange {
                                // Extraemos el texto desde el final del código anterior hasta el comienzo del código actual.
                                let productInfoRange = prevRange.upperBound..<range.lowerBound
                                let productInfo = currentLine[productInfoRange].trimmingCharacters(in: .whitespacesAndNewlines)
                                
                                // Construimos la línea completa para este producto, incluyendo el código anterior y la información del producto.
                                let fullProductLine = currentLine[prevRange] + " " + productInfo
                                
                                if !fullProductLine.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    processedLines.append(String(fullProductLine))
                                }
                            }
                            previousRange = range
                        }
                    }
                    // Tratar el último producto de la línea, si existe, después del último código.
                    if let lastRange = previousRange {
                        let lastProductInfo = currentLine[lastRange.upperBound...].trimmingCharacters(in: .whitespacesAndNewlines)
                        if !lastProductInfo.isEmpty {
                            // Para el último segmento, incluimos el último código de producto y su descripción correspondiente.
                            let lastFullProductLine = currentLine[lastRange] + " " + lastProductInfo
                            processedLines.append(String(lastFullProductLine))
                        }
                    }
                }else {
                    // Si no hay necesidad de dividir, procesamos normalmente.
                    if line.range(of: "X \\$[0-9,]+", options: .regularExpression) != nil && i + 1 < finalTextLines.count {
                        let nextLine = finalTextLines[i + 1]
                        let combinedLine = "\(line) \(nextLine)"
                        processedLines.append(combinedLine)
                        skipNextLine = true
                    } else {
                        processedLines.append(currentLine)
                    }
                }

                // Deja de grabar si encontramos "TOTAL".
                if line.contains("TOTAL") {
                    break
                }
            }
        }
        // Filtramos las líneas procesadas para eliminar aquellas que puedan ser ruido o irrelevantes.
        let meaningfulLines = processedLines.filter { line in
            let words = line.split(whereSeparator: { $0.isWhitespace })
            return words.count >= 2
        }

        return meaningfulLines.joined(separator: "\n")
    }
    
    func getProductCodes(currentLine: String) -> [String]{
        let regexPattern = "\\b\\d{10,}\\b"

        do {
            let regex = try NSRegularExpression(pattern: regexPattern)
            let results = regex.matches(in: currentLine,
                                        range: NSRange(currentLine.startIndex..., in: currentLine))
            
            // Convertir los resultados a un array de códigos de producto.
            let productCodes = results.map {
                String(currentLine[Range($0.range, in: currentLine)!])
            }

            return productCodes
        } catch let error {
            print(error)
            return []
        }
    }
    
    func replaceLetterOWithZero(in text: String) -> String {
        // Define la expresión regular para encontrar 'O' o 'o' precedida por un dígito.
        let pattern = "(?<=\\b|\\d)[OoÓó]"

        // Intenta crear una expresión regular con el patrón.
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            // Si la expresión regular no es válida (lo cual sería raro), devuelve el texto sin cambios.
            return text
        }

        // Define el rango de todo el texto.
        let range = NSRange(text.startIndex..., in: text)

        // Reemplaza las ocurrencias encontradas en el rango con "0".
        let correctedText = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "0")

        return correctedText
    }
    
    func getOCRbyVendor(vendorName: String, finalTextLines: [String]) -> String{
        if vendorName == "D1"{
            return getOCRProcess(finalTextLines: finalTextLines)
        }
        if vendorName == "" {
            return ""
        }
        if vendorName == "Almacenes Exito"{
            return getOCRProcessExito(finalTextLines: finalTextLines)
        }
        else {
            return ""
        }
    }

}
