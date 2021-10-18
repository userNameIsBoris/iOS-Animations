//
//  ViewController.swift
//  MultiplayerSearch
//
//  Created by Boris Ezhov on 13.10.2021.
//

import UIKit

final class ViewController: UIViewController {
  @IBOutlet private var myAvatar: AvatarView!
  @IBOutlet private var opponentAvatar: AvatarView!

  @IBOutlet private var status: UILabel!
  @IBOutlet private var vs: UILabel!
  @IBOutlet private var searchAgain: UIButton!

  // MARK: - Life Cycle
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchForOpponent()
  }

  // MARK: - Methods
  private func searchForOpponent() {
    let avatarSize = myAvatar.frame.size
    let bounceXOffset: CGFloat = avatarSize.width / 1.9
    let morphSize = CGSize(
      width: avatarSize.width * 0.85,
      height: avatarSize.height * 1.1)

    let rightBouncePoint = CGPoint(
      x: view.frame.size.width / 2 + bounceXOffset,
      y: myAvatar.center.y)
    let leftBouncePoint = CGPoint(
      x: view.frame.size.width / 2 - bounceXOffset,
      y: myAvatar.center.y)

    myAvatar.bounceOff(point: rightBouncePoint, morphSize: morphSize)
    opponentAvatar.bounceOff(point: leftBouncePoint, morphSize: morphSize)

    DispatchQueue.main.asyncAfter(deadline: .now() + 4) { self.foundOpponent() }
  }

  private func foundOpponent() {
    status.text = "Connecting..."

    opponentAvatar.image = UIImage(named: "avatar-2")
    opponentAvatar.name = "Ray"

    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
      self.connectedToOpponent()
    }
  }

  private func connectedToOpponent() {
    myAvatar.shouldTransitionToFinishedState = true
    opponentAvatar.shouldTransitionToFinishedState = true

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.completed()
    }
  }

  private func completed() {
    status.text = "Completed"

    UIView.animate(withDuration: 0.2) {
      self.vs.alpha = 1
      self.searchAgain.alpha = 1
    }
  }

  @IBAction private func actionSearchAgain() {
    let vc = storyboard!.instantiateViewController(withIdentifier: "ViewController") as UIViewController
    UIApplication.shared.keyWindow?.rootViewController = vc
  }
}
