//
//  ViewController.swift
//  BahamaAir
//
//  Created by Boris Ezhov 23.09.2021.
//

import UIKit

final class ViewController: UIViewController {
  @IBOutlet private var loginButton: UIButton!
  @IBOutlet private var headingLabel: UILabel!
  @IBOutlet private var usernameTextField: UITextField!
  @IBOutlet private var passwordTextField: UITextField!
  @IBOutlet private var cloud1: UIImageView!
  @IBOutlet private var cloud2: UIImageView!
  @IBOutlet private var cloud3: UIImageView!
  @IBOutlet private var cloud4: UIImageView!

  private let spinner = UIActivityIndicatorView(style: .large)
  private let status = UIImageView(image: UIImage(named: "banner"))
  private let label = UILabel()
  private let info = UILabel()
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
    setupFormAnimation()
    setupOtherAnimations()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animateClouds()
    usernameTextField.delegate = self
    passwordTextField.delegate = self
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

    info.frame = CGRect(x: 0, y: loginButton.center.y + 60, width: view.frame.size.width, height: 30)
    info.text = "Tap on a field and enter username and password"
    info.font = UIFont(name: "HelveticaNeue", size: 12)
    info.textAlignment = .center
    info.textColor = UIColor.white
    info.backgroundColor = UIColor.clear
    view.insertSubview(info, belowSubview: loginButton)
  }

  private func setupFormAnimation() {
    let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
    fadeInAnimation.fromValue = 0.25
    fadeInAnimation.toValue = 1

    let flyRightAnimation = CABasicAnimation(keyPath: "position.x")
    flyRightAnimation.fromValue = -view.bounds.width / 2
    flyRightAnimation.toValue = view.bounds.width / 2

    let animationGroup = CAAnimationGroup()
    animationGroup.animations = [fadeInAnimation, flyRightAnimation]
    animationGroup.fillMode = .backwards
    animationGroup.duration = 0.5
    animationGroup.delegate = self

    headingLabel.layer.add(animationGroup, forKey: nil)

    animationGroup.setValue("form", forKey: "name")
    animationGroup.beginTime = CACurrentMediaTime() + 0.3
    animationGroup.setValue(usernameTextField.layer, forKey: "layer")
    usernameTextField.layer.add(animationGroup, forKey: nil)

    animationGroup.beginTime = CACurrentMediaTime() + 0.4
    animationGroup.setValue(passwordTextField.layer, forKey: "layer")
    passwordTextField.layer.add(animationGroup, forKey: nil)
  }

  private func setupOtherAnimations() {
    let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
    fadeInAnimation.fromValue = 0
    fadeInAnimation.toValue = 1
    fadeInAnimation.duration = 0.5
    fadeInAnimation.fillMode = .backwards

    fadeInAnimation.beginTime = CACurrentMediaTime() + 0.5
    cloud1.layer.add(fadeInAnimation, forKey: nil)
    fadeInAnimation.beginTime = CACurrentMediaTime() + 0.7
    cloud2.layer.add(fadeInAnimation, forKey: nil)
    fadeInAnimation.beginTime = CACurrentMediaTime() + 0.9
    cloud3.layer.add(fadeInAnimation, forKey: nil)
    fadeInAnimation.beginTime = CACurrentMediaTime() + 1.1
    cloud4.layer.add(fadeInAnimation, forKey: nil)

    let animationGroup = CAAnimationGroup()
    animationGroup.timingFunction = CAMediaTimingFunction(name: .easeIn)
    animationGroup.beginTime = CACurrentMediaTime() + 0.5
    animationGroup.duration = 0.5
    animationGroup.fillMode = .backwards
    let scaleDown = CABasicAnimation(keyPath: "transform.scale")
    scaleDown.fromValue = 3.5
    scaleDown.toValue = 1
    let rotation = CABasicAnimation(keyPath: "transform.rotation")
    rotation.fromValue = .pi / 4.0
    rotation.toValue = 0
    let fadeIn = CABasicAnimation(keyPath: "opacity")
    fadeIn.fromValue = 0
    fadeIn.toValue = 1
    animationGroup.animations = [scaleDown, rotation, fadeIn]
    loginButton.layer.add(animationGroup, forKey: nil)

    let flyLeft = CABasicAnimation(keyPath: "position.x")
    flyLeft.autoreverses = true
    flyLeft.fromValue = info.layer.position.x + view.frame.size.width
    flyLeft.toValue = info.layer.position.x
    flyLeft.duration = 5
    info.layer.add(flyLeft, forKey: "infoappear")

    let fadeLabelIn = CABasicAnimation(keyPath: "opacity")
    fadeLabelIn.fromValue = 0.2
    fadeLabelIn.toValue = 1.0
    fadeLabelIn.duration = 4.5
    info.layer.add(fadeLabelIn, forKey: "fadein")
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
      self.spinner.center = CGPoint(x: 40, y: self.loginButton.frame.size.height / 2)
      self.spinner.alpha = 1
    }
    let tintColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1)
    tintBackgroundColor(layer: loginButton.layer, toColor: tintColor.cgColor)
    roundCorners(layer: loginButton.layer, toRadius: 25)

    let initialPosition = CGPoint(x: -50, y: 0)
    let finalPosition = CGPoint(x: -50, y: loginButton.center.y)
    let balloonLayer = CALayer()
    balloonLayer.contents = UIImage(named: "balloon")?.cgImage
    balloonLayer.frame = CGRect(x: initialPosition.x, y: initialPosition.y, width: 50, height: 65)
    view.layer.insertSublayer(balloonLayer, below: usernameTextField.layer)

    let flightAnimation = CAKeyframeAnimation(keyPath: "position")
    flightAnimation.duration = 12
    flightAnimation.values = [
      initialPosition,
      CGPoint(x: view.frame.width + 50, y: 160),
      finalPosition,
    ].map { NSValue(cgPoint: $0) }
    flightAnimation.keyTimes = [0, 0.5, 1]

    balloonLayer.add(flightAnimation, forKey: nil)
    balloonLayer.position = finalPosition
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
      }, completion: { _ in
        let tintColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1)
        tintBackgroundColor(layer: self.loginButton.layer, toColor: tintColor.cgColor)
        roundCorners(layer: self.loginButton.layer, toRadius: 10)
      })
    UIView.animate(withDuration: 0.2) {
      self.spinner.center = CGPoint(x: -20, y: 16)
      self.spinner.alpha = 0
      self.loginButton.bounds.size.width -= 80
      self.loginButton.center.y -= 60
      self.loginButton.isEnabled = true
    }
  
    let wobbleAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
    wobbleAnimation.duration = 0.25
    wobbleAnimation.repeatCount = 4
    wobbleAnimation.values = [0, -.pi / 4.0, 0, .pi / 4.0, 0]
    wobbleAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
    headingLabel.layer.add(wobbleAnimation, forKey: nil)
  }

  private func animateClouds() {
    animateCloud(layer: cloud1.layer)
    animateCloud(layer: cloud2.layer)
    animateCloud(layer: cloud3.layer)
    animateCloud(layer: cloud4.layer)
  }

  private func animateCloud(layer: CALayer) {
    let cloudSpeed = 60 / view.frame.size.width
    let duration = (view.frame.size.width - layer.frame.origin.x) * cloudSpeed

    let cloudMove = CABasicAnimation(keyPath: "position.x")
    cloudMove.duration = duration
    cloudMove.toValue = self.view.bounds.width + layer.bounds.width / 2
    cloudMove.delegate = self
    cloudMove.setValue("cloud", forKey: "name")
    cloudMove.setValue(layer, forKey: "layer")
    layer.add(cloudMove, forKey: nil)
  }
}

extension ViewController: CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    guard let name = anim.value(forKey: "name") as? String else { return }

    if name == "form" {
      let layer = anim.value(forKey: "layer") as? CALayer
      anim.setValue(nil, forKey: "layer")

      let pulse = CASpringAnimation(keyPath: "transform.scale")
      pulse.damping = 7.5
      pulse.fromValue = 1.25
      pulse.toValue = 1
      pulse.duration = pulse.settlingDuration
      layer?.add(pulse, forKey: nil)
    }

    if name == "cloud", let layer = anim.value(forKey: "layer") as? CALayer {
      layer.position.x = -layer.bounds.width
      layer.setValue(nil, forKey: "layer")
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.animateCloud(layer: layer)
      }
    }
  }
}

extension ViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nextField = (textField === usernameTextField) ? passwordTextField : usernameTextField
    nextField?.becomeFirstResponder()
    return true
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    guard info.layer.animationKeys() != nil else { return }
    info.layer.removeAnimation(forKey: "infoappear")
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let text = textField.text, text.count < 5 else { return }
    let jumpAnimation = CASpringAnimation(keyPath: "position.y")
    jumpAnimation.initialVelocity = 100
    jumpAnimation.mass = 10
    jumpAnimation.stiffness = 1500
    jumpAnimation.damping = 50
    jumpAnimation.fromValue = textField.layer.position.y + 1
    jumpAnimation.toValue = textField.layer.position.y
    jumpAnimation.duration = jumpAnimation.settlingDuration
    textField.layer.add(jumpAnimation, forKey: nil)

    textField.layer.borderWidth = 3
    textField.layer.borderColor = UIColor.clear.cgColor

    let flashAnimation = CASpringAnimation(keyPath: "borderColor")
    flashAnimation.damping = 7
    flashAnimation.stiffness = 200
    flashAnimation.fromValue = CGColor(red: 1, green: 0.27, blue: 0, alpha: 1)// UIColor(red: 1, green: 0.27, blue: 0, alpha: 1).cgColor
    flashAnimation.toValue = UIColor.white.cgColor
    flashAnimation.duration = flashAnimation.settlingDuration
    textField.layer.add(flashAnimation, forKey: nil)
    textField.layer.cornerRadius = 5
  }
}
