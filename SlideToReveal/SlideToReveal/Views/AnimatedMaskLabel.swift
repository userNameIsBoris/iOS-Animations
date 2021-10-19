//
//  AnimatedMaskLabel.swift
//  SlideToReveal
//
//  Created by Boris Ezhov on 19.10.2021.
//

import UIKit

@IBDesignable final class AnimatedMaskLabel: UIView {

  private let gradientLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
    let colors = [
      UIColor.red.cgColor,
      UIColor.orange.cgColor,
      UIColor.yellow.cgColor,
      UIColor.green.cgColor,
      UIColor.blue.cgColor,
      UIColor.red.cgColor,
    ]
    gradientLayer.colors = colors

    let locations: [NSNumber] = [0.25, 0.5, 0.75]
    gradientLayer.locations = locations

    return gradientLayer
  }()

  private let textAttributes: [NSAttributedString.Key: Any] = {
    let style = NSMutableParagraphStyle()
    style.alignment = .center
    return [
      .font: UIFont(name: "HelveticaNeue-Thin", size: 28)!,
      .paragraphStyle: style
    ]
  }()

  @IBInspectable var text: String! {
    didSet {
      setNeedsDisplay()
      let image = UIGraphicsImageRenderer(size: bounds.size)
        .image { _ in
          text.draw(in: bounds, withAttributes: textAttributes)
      }
      let maskLayer = CALayer()
      maskLayer.backgroundColor = UIColor.clear.cgColor
      maskLayer.frame = bounds.offsetBy(dx: bounds.width, dy: 0)
      maskLayer.contents = image.cgImage
      gradientLayer.mask = maskLayer
    }
  }

  // MARK: - Methods
  override func layoutSubviews() {
    layer.borderColor = UIColor.green.cgColor
    gradientLayer.frame = CGRect(x: -bounds.width, y: bounds.origin.y, width: 3 * bounds.width, height: bounds.height)
  }

  override func didMoveToWindow() {
    super.didMoveToWindow()
    layer.addSublayer(gradientLayer)

    let gradientAnimation = CABasicAnimation(keyPath: "locations")
    gradientAnimation.fromValue = [0, 0, 0, 0, 0, 0.25]
    gradientAnimation.toValue = [0.65, 0.8, 0.85, 0.9, 0.95, 1]
    gradientAnimation.duration = 3
    gradientAnimation.repeatCount = .infinity

    gradientLayer.add(gradientAnimation, forKey: nil)
  }
}
