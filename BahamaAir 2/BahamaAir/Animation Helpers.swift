//
//  Animation Helpers.swift
//  BahamaAir
//
//  Created by Boris Ezhov on 06.10.2021.
//

import UIKit

func tintBackgroundColor(layer: CALayer, toColor: CGColor) {
  let animation = CABasicAnimation(keyPath: "backgroundColor")
  animation.fromValue = layer.backgroundColor
  animation.toValue = toColor
  animation.duration = 1

  layer.add(animation, forKey: nil)
  layer.backgroundColor = toColor
}

func roundCorners(layer: CALayer, toRadius: CGFloat) {
  let animation = CABasicAnimation(keyPath: "cornerRadius")
  animation.fromValue = layer.cornerRadius
  animation.toValue = toRadius
  animation.duration = 0.33

  layer.add(animation, forKey: nil)
  layer.cornerRadius = toRadius
}
