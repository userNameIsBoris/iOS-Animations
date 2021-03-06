//
//  ViewController.swift
//  BahamaAir
//
//  Created by Boris Ezhov 23.09.2021.
//

import UIKit

final class ViewController: UIViewController {
  @IBOutlet private var loginButton: UIButton!
  @IBOutlet private var heading: UILabel!
  @IBOutlet private var username: UITextField!
  @IBOutlet private var password: UITextField!
  @IBOutlet private var cloud1: UIImageView!
  @IBOutlet private var cloud2: UIImageView!
  @IBOutlet private var cloud3: UIImageView!
  @IBOutlet private var cloud4: UIImageView!

  private let spinner = UIActivityIndicatorView(style: .large)
  private let status = UIImageView(image: UIImage(named: "banner"))
  private let label = UILabel()
  private let messages = [
    "Connecting...",
    "Authorizing...",
    "Sending credentials...",
    "Failed"
  ]
  private var statusCenter = CGPoint.zero

  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    prepareForAnimation()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animateOnAppear()
    animateClouds()
  }

  // MARK: Methods
  private func setupView() {
    loginButton.layer.cornerRadius = 8
    loginButton.layer.masksToBounds = true

    spinner.frame = CGRect(x: -20, y: 6, width: 20, height: 20)
    spinner.startAnimating()
    spinner.alpha = 0
    loginButton.addSubview(spinner)
    
    status.isHidden = true
    status.center = loginButton.center
    view.addSubview(status)
    
    label.frame = CGRect(x: 0, y: 0, width: status.frame.size.width, height: status.frame.size.height)
    label.font = UIFont(name: "HelveticaNeue", size: 18)
    label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0, alpha: 1)
    label.textAlignment = .center
    status.addSubview(label)
    statusCenter = status.center
  }

  private func prepareForAnimation() {
    heading.center.x -= view.bounds.width
    username.center.x -= view.bounds.width
    password.center.x -= view.bounds.width
    cloud1.alpha = 0
    cloud2.alpha = 0
    cloud3.alpha = 0
    cloud4.alpha = 0
    loginButton.center.y += 30
    loginButton.alpha = 0
  }

  private func animateOnAppear() {
    UIView.animate(withDuration: 0.5) {
      self.heading.center.x += self.view.bounds.width
    }
    UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.65, initialSpringVelocity: 0, options: []) {
      self.username.center.x += self.view.bounds.width
    }
    UIView.animate(withDuration: 0.5, delay: 0.4, usingSpringWithDamping: 0.65, initialSpringVelocity: 0, options: []) {
      self.password.center.x += self.view.bounds.width
    }
    // Clouds
    UIView.animate(withDuration: 0.5, delay: 0.5, options: []) {
      self.cloud1.alpha = 1
    }
    UIView.animate(withDuration: 0.5, delay: 0.7, options: []) {
      self.cloud2.alpha = 1
    }
    UIView.animate(withDuration: 0.5, delay: 0.9, options: []) {
      self.cloud3.alpha = 1
    }
    UIView.animate(withDuration: 0.5, delay: 1.1, options: []) {
      self.cloud4.alpha = 1
    }
    // Login Button
    UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: []) {
      self.loginButton.center.y -= 30
      self.loginButton.alpha = 1
    }
  }

  @IBAction private func login() {
    view.endEditing(true)
    UIView.animate(
      withDuration: 1.5,
      delay: 0,
      usingSpringWithDamping: 0.2,
      initialSpringVelocity: 0,
      options: [],
      animations: {
      self.loginButton.bounds.size.width += 80
    }, completion: { _ in
      self.loginButton.isEnabled = false
      self.showMessage(index: 0)
    })
    UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: []) {
      self.loginButton.center.y += 60
      self.loginButton.backgroundColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1)
      self.spinner.center = CGPoint(x: 40, y: self.loginButton.frame.size.height / 2)
      self.spinner.alpha = 1
    }
  }

  private func showMessage(index: Int) {
    label.text = messages[index]

    UIView.transition(
      with: status,
      duration: 0.33,
      options: [.curveEaseOut, .transitionFlipFromTop],
      animations: {
        self.status.isHidden = false
      },
      completion: { _ in
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          guard index < self.messages.count - 1 else {
            self.resetForm()
            return
          }
          self.removeMessage(index: index)
        }
      })
  }

  private func removeMessage(index: Int) {
    UIView.animate(
      withDuration: 0.33,
      animations: {
        self.status.center.x += self.view.frame.size.width
      },
      completion: { _ in
        self.status.isHidden = true
        self.status.center = self.statusCenter
        self.showMessage(index: index + 1)
      })
  }

  private func resetForm() {
    UIView.transition(
      with: status,
      duration: 0.2,
      options: .transitionFlipFromBottom,
      animations: {
        self.status.isHidden = true
        self.status.center = self.statusCenter
      }, completion: nil)
    UIView.animate(withDuration: 0.2) {
      self.spinner.center = CGPoint(x: -20, y: 16)
      self.spinner.alpha = 0
      self.loginButton.backgroundColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1)
      self.loginButton.bounds.size.width -= 80
      self.loginButton.center.y -= 60
      self.loginButton.isEnabled = true
    }
  }

  private func animateClouds() {
    animateCloud(cloud1)
    animateCloud(cloud2)
    animateCloud(cloud3)
    animateCloud(cloud4)
  }

  private func animateCloud(_ cloud: UIImageView) {
    let cloudSpeed = 60 / view.frame.size.width
    let duration = (view.frame.size.width - cloud.center.x) * cloudSpeed
    UIView.animate(
      withDuration: duration,
      delay: 0,
      options: .curveLinear,
      animations: {
        cloud.frame.origin.x = self.view.frame.size.width
      }, completion: { _ in
        cloud.frame.origin.x = -cloud.frame.size.width
        self.animateCloud(cloud)
      })
  }

  // MARK: UITextFieldDelegate
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nextField = (textField === username) ? password : username
    nextField?.becomeFirstResponder()
    return true
  }
  
}
