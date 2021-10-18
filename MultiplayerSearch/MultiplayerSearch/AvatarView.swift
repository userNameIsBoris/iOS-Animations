//
//  AvatarView.swift
//  MultiplayerSearch
//
//  Created by Boris Ezhov on 13.10.2021.
//

import UIKit

@IBDesignable
final class AvatarView: UIView {
  private enum Constants {
    static let lineWidth: CGFloat = 6
    static let animationDuration = 1.0
  }

  var shouldTransitionToFinishedState = false
  private var isSquare = false

  @IBInspectable var image: UIImage? {
    didSet { photoLayer.contents = image?.cgImage }
  }
  @IBInspectable var name: String? {
    didSet { label.text = name }
  }

  private let photoLayer = CALayer()
  private let circleLayer = CAShapeLayer()
  private let maskLayer = CAShapeLayer()
  private let label: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "ArialRoundedMTBold", size: 18)
    label.textAlignment = .center
    label.textColor = UIColor.black
    return label
  }()

  // MARK: - Overridden Methods
  override func didMoveToWindow() {
    photoLayer.mask = maskLayer
    layer.addSublayer(photoLayer)
    layer.addSublayer(circleLayer)
    addSubview(label)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    guard let image = image else { return }

    //Size the avatar image to fit
    photoLayer.frame = CGRect(
      x: (bounds.size.width - image.size.width + Constants.lineWidth) / 2,
      y: (bounds.size.height - image.size.height - Constants.lineWidth) / 2,
      width: image.size.width,
      height: image.size.height)

    //Draw the circle
    circleLayer.path = UIBezierPath(ovalIn: bounds).cgPath
    circleLayer.strokeColor = UIColor.white.cgColor
    circleLayer.lineWidth = Constants.lineWidth
    circleLayer.fillColor = UIColor.clear.cgColor

    //Size the layer
    maskLayer.path = circleLayer.path
    maskLayer.position = CGPoint(x: 0, y: 10)

    //Size the label
    label.frame = CGRect(x: 0, y: bounds.size.height + 10, width: bounds.size.width, height: 24)
  }

  // MARK: - Methods
  func bounceOff(point: CGPoint, morphSize: CGSize) {
    let originalCenter = center

    UIView.animate(
      withDuration: Constants.animationDuration,
      delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0,
      animations: {
        self.center = point
      }, completion: { _ in
        guard self.shouldTransitionToFinishedState else { return }
        self.animateToSquare()
      })

    UIView.animate(
      withDuration: Constants.animationDuration,
      delay: Constants.animationDuration,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 1,
      animations: {
        self.center = originalCenter
      }, completion: { _ in
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          guard !self.isSquare else { return }
          self.bounceOff(point: point, morphSize: morphSize)
        }
      })

    let x = (originalCenter.x > point.x) ? 0 : bounds.width - morphSize.width
    let origin = CGPoint(x: x, y: bounds.height - morphSize.height)
    let morphedFrame = CGRect(origin: origin, size: morphSize)

    let morphAnimation = CABasicAnimation(keyPath: "path")
    morphAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
    morphAnimation.duration = Constants.animationDuration
    morphAnimation.toValue = UIBezierPath(ovalIn: morphedFrame).cgPath
    circleLayer.add(morphAnimation, forKey: nil)
    maskLayer.add(morphAnimation, forKey: nil)
  }

  private func animateToSquare() {
    isSquare = true
    let squarePath = UIBezierPath(rect: bounds).cgPath

    let animation = CABasicAnimation(keyPath: "path")
    animation.duration = 0.25
    animation.fromValue = circleLayer.path
    animation.toValue = squarePath
    circleLayer.add(animation, forKey: nil)
    circleLayer.path = squarePath
    maskLayer.add(animation, forKey: nil)
    maskLayer.path = squarePath
  }
}
