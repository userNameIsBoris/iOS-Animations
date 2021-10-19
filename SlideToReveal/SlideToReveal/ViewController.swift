//
//  ViewController.swift
//  SlideToReveal
//
//  Created by Boris Ezhov on 19.10.2021.
//

import UIKit

final class ViewController: UIViewController {

  @IBOutlet private var slideView: AnimatedMaskLabel!
  @IBOutlet private var time: UILabel!

  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    addSwipeRecognizer()
  }

  // MARK: - Methods
  private func addSwipeRecognizer() {
    let action = #selector(didSlide)
    let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: action)
    swipeRecognizer.direction = .right
    slideView.addGestureRecognizer(swipeRecognizer)
  }

  @objc private func didSlide() {
    let image = UIImage(named: "Meme")
    let imageView = UIImageView(image: image)
    let centerX = view.center.x + view.bounds.width
    imageView.center = CGPoint(x: centerX , y: view.center.y)
    imageView.layer.cornerRadius = 25
    imageView.layer.masksToBounds = true
    view.addSubview(imageView)

    UIView.animate(withDuration: 0.33, delay: 0) {
      self.time.center.y -= 200
      self.slideView.center.y += 200
      imageView.center.x -= self.view.bounds.width
    }

    UIView.animate(
      withDuration: 0.33,
      delay: 1,
      animations: {
        self.time.center.y += 200
        self.slideView.center.y -= 200
        imageView.center.x += self.view.bounds.width
      }, completion: { _ in
        imageView.removeFromSuperview()
      }
    )
  }
}
