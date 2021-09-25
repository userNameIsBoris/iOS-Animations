//
//  SnowView.swift
//  Flights
//
//  Created by Boris Ezhov on 25.09.2021.
//

import UIKit

final class SnowView: UIView {
  override class var layerClass: AnyClass {
    return CAEmitterLayer.self
  }

  // MARK: - Initializers
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }

  // MARK: - Methods
  private func setupView() {
    let emitter = layer as! CAEmitterLayer
    emitter.emitterPosition = CGPoint(x: bounds.size.width / 2, y: 0)
    emitter.emitterSize = bounds.size
    emitter.emitterShape = .rectangle

    let emitterCell = CAEmitterCell()
    emitterCell.contents = UIImage(named: "flake")!.cgImage
    emitterCell.birthRate = 200
    emitterCell.lifetime = 3.5
    emitterCell.color = UIColor.white.cgColor
    emitterCell.redRange = 0
    emitterCell.blueRange = 0.1
    emitterCell.greenRange = 0
    emitterCell.velocity = 10
    emitterCell.velocityRange = 350
    emitterCell.emissionRange = Double.pi / 2
    emitterCell.emissionLongitude = -Double.pi
    emitterCell.yAcceleration = 70
    emitterCell.xAcceleration = 0
    emitterCell.scale = 0.33
    emitterCell.scaleRange = 1.25
    emitterCell.scaleSpeed = -0.25
    emitterCell.alphaRange = 0.5
    emitterCell.alphaSpeed = -0.15

    emitter.emitterCells = [emitterCell]
  }
}
