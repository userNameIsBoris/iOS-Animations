//
//  Animation Helpers.swift
//  BahamaAir
//
//  Created by Boris Ezhov on 06.10.2021.
//

import UIKit

func tintBackgroundColor(layer: CALayer, toColor: CGColor) {
  let animation = CASpringAnimation(keyPath: "backgroundColor")
  animation.damping = 5
  animation.initialVelocity = -10
  animation.fromValue = layer.backgroundColor
  animation.toValue = toColor
  animation.duration = animation.settlingDuration
  
  layer.add(animation, forKey: nil)
  layer.backgroundColor = toColor
}

func roundCorners(layer: CALayer, toRadius: CGFloat) {
  let animation = CASpringAnimation(keyPath: "cornerRadius")
  animation.damping = 5
  animation.fromValue = layer.cornerRadius
  animation.toValue = toRadius
  animation.duration = animation.settlingDuration

  layer.add(animation, forKey: nil)
  layer.cornerRadius = toRadius
}
