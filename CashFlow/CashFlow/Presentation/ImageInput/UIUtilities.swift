//
//  UIUtilities.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 14/09/23.
//

import Foundation
import UIKit

public class UIUtilities {
    
    public static func addRectangle(_ rectangle: CGRect, to view: UIView, color: UIColor) {
      guard rectangle.isValid() else { return }
      let rectangleView = UIView(frame: rectangle)
      rectangleView.layer.cornerRadius = Constants.rectangleViewCornerRadius
      rectangleView.alpha = Constants.rectangleViewAlpha
      rectangleView.backgroundColor = color
      rectangleView.isAccessibilityElement = true
      rectangleView.accessibilityIdentifier = Constants.rectangleViewIdentifier
      view.addSubview(rectangleView)
    }
    
    
    
}

// MARK: - Constants

private enum Constants {
  static let circleViewAlpha: CGFloat = 0.7
  static let rectangleViewAlpha: CGFloat = 0.3
  static let shapeViewAlpha: CGFloat = 0.3
  static let rectangleViewCornerRadius: CGFloat = 10.0
  static let maxColorComponentValue: CGFloat = 255.0
  static let originalScale: CGFloat = 1.0
  static let bgraBytesPerPixel = 4
  static let circleViewIdentifier = "MLKit Circle View"
  static let lineViewIdentifier = "MLKit Line View"
  static let rectangleViewIdentifier = "MLKit Rectangle View"
}

// MARK: - Extension

extension CGRect {
  /// Returns a `Bool` indicating whether the rectangle's values are valid`.
  func isValid() -> Bool {
    return
      !(origin.x.isNaN || origin.y.isNaN || width.isNaN || height.isNaN || width < 0 || height < 0)
  }
}
