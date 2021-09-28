//
//  HorizontalItemList.swift
//  PackingList
//
//  Created by Boris Ezhov on 28.09.2021.
//

import UIKit

final class HorizontalItemList: UIScrollView {
  var didSelectItem: ((_ index: Int)->())?
  private let buttonWidth: CGFloat = 60
  private let padding: CGFloat = 10

  // MARK: - Initializers
  convenience init(inView: UIView) {
    let rect = CGRect(x: inView.bounds.width, y: 120, width: inView.frame.width, height: 80)
    self.init(frame: rect)
    
    alpha = 0
    
    for i in 0..<10 {
      let image = UIImage(named: "summericons_100px_0\(i)")
      let imageView = UIImageView(image: image)
      imageView.center = CGPoint(x: CGFloat(i) * buttonWidth + buttonWidth / 2, y: buttonWidth / 2)
      imageView.tag = i
      imageView.isUserInteractionEnabled = true
      addSubview(imageView)

      let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(HorizontalItemList.didTapImage(_:)))
      imageView.addGestureRecognizer(tapRecognizer)
    }
    contentSize = CGSize(width: padding * buttonWidth, height:  buttonWidth + 2 * padding)
  }

  // MARK: - Methods
  @objc private func didTapImage(_ tapRecognizer: UITapGestureRecognizer) {
    didSelectItem?(tapRecognizer.view!.tag)
  }

  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    guard superview != nil else { return }
    UIView.animate(withDuration: 1, delay: 0.01, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseIn) {
      self.alpha = 1
      self.center.x -= self.frame.size.width
    }
  }
}
