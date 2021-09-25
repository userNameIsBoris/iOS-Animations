//
//  ViewController.swift
//  Flights
//
//  Created by Boris Ezhov on 25.09.2021.
//

import UIKit

final class ViewController: UIViewController {
  private enum AnimationDirection: CGFloat {
    case positive = 1
    case negative = -1
  }

  private enum Flights {
    static let londonToParis = FlightData(
      summary: "01 Apr 2015 09:42",
      flightNumber: "ZY 2014",
      gateNumber: "T1 A33",
      departingFrom: "LGW",
      arrivingTo: "CDG",
      weatherImageName: "bg-snowy",
      showWeatherEffects: true,
      isTakingOff: true,
      flightStatus: "Boarding")
    static let parisToRome = FlightData(
      summary: "01 Apr 2015 17:05",
      flightNumber: "AE 1107",
      gateNumber: "045",
      departingFrom: "CDG",
      arrivingTo: "FCO",
      weatherImageName: "bg-sunny",
      showWeatherEffects: false,
      isTakingOff: false,
      flightStatus: "Delayed")
  }

  @IBOutlet private var bgImageView: UIImageView!
  @IBOutlet private var summaryIcon: UIImageView!
  @IBOutlet private var summary: UILabel!
  @IBOutlet private var flightNr: UILabel!
  @IBOutlet private var gateNr: UILabel!
  @IBOutlet private var departingFrom: UILabel!
  @IBOutlet private var arrivingTo: UILabel!
  @IBOutlet private var planeImage: UIImageView!
  @IBOutlet private var flightStatus: UILabel!
  @IBOutlet private var statusBanner: UIImageView!
  
  private var snowView: SnowView!

  
  //MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    changeFlight(to: Flights.londonToParis, animated: false)
  }

  // MARK: - Methods
  private func setupView() {
    summary.addSubview(summaryIcon)
    summaryIcon.center.y = summary.frame.size.height / 2

    let snowViewFrame = CGRect(x: -150, y: -100, width: 300, height: 50)
    snowView = SnowView(frame: snowViewFrame)
    let snowClipView = UIView(frame: view.frame.offsetBy(dx: 0, dy: 50))
    snowClipView.clipsToBounds = true
    snowClipView.addSubview(snowView)
    view.addSubview(snowClipView)
  }

  private func changeFlight(to flight: FlightData, animated: Bool) {
    summary.text = flight.summary
    let image = UIImage(named: flight.weatherImageName)
    if animated {
      fade(imageView: bgImageView, toImage: image, showEffects: flight.showWeatherEffects)

      let direction: AnimationDirection = flight.isTakingOff ? .positive : .negative
      cubeTransition(label: flightNr, text: flight.flightNumber, direction: direction)
      cubeTransition(label: gateNr, text: flight.gateNumber, direction: direction)

      let offsetByX = CGFloat(direction.rawValue * 80)
      let offsetDeparting = CGPoint(x: offsetByX, y: 0)
      moveLabel(label: departingFrom, text: flight.departingFrom, offset: offsetDeparting)
      let offsetArriving = CGPoint(x: -offsetByX, y: 0)
      moveLabel(label: arrivingTo, text: flight.arrivingTo, offset: offsetArriving)

      cubeTransition(label: flightStatus, text: flight.flightStatus, direction: direction)
    } else {
      bgImageView.image = image
      snowView.isHidden = !flight.showWeatherEffects
      flightNr.text = flight.flightNumber
      gateNr.text = flight.gateNumber
      departingFrom.text = flight.departingFrom
      arrivingTo.text = flight.arrivingTo
      flightStatus.text = flight.flightStatus
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.changeFlight(to: flight.isTakingOff ? Flights.parisToRome : Flights.londonToParis, animated: true)
    }
  }

  private func fade(imageView: UIImageView, toImage: UIImage?, showEffects: Bool) {
    UIView.transition(with: imageView, duration: 1, options: .transitionCrossDissolve) {
      imageView.image = toImage
    }
    UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
      self.snowView.alpha = showEffects ? 1 : 0
    }
  }

  private func cubeTransition(label: UILabel, text: String, direction: AnimationDirection) {
    let auxiliaryLabel = UILabel(frame: label.frame)
    auxiliaryLabel.text = text
    auxiliaryLabel.font = label.font
    auxiliaryLabel.textAlignment = label.textAlignment
    auxiliaryLabel.textColor = label.textColor
    auxiliaryLabel.backgroundColor = label.backgroundColor
    view.addSubview(auxiliaryLabel)

    let auxLabelOffset = direction.rawValue * label.frame.size.height / 2
    auxiliaryLabel.transform = CGAffineTransform(translationX: 0, y: auxLabelOffset).scaledBy(x: 1, y: 0.1)

    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      options: .curveEaseOut,
      animations: {
        auxiliaryLabel.transform = .identity
        label.transform = CGAffineTransform(translationX: 0, y: -auxLabelOffset).scaledBy(x: 1, y: 0.1)
      }, completion: { _ in
        label.text = auxiliaryLabel.text
        label.transform = .identity
        auxiliaryLabel.removeFromSuperview()
      })
  }

  private func moveLabel(label: UILabel, text: String, offset: CGPoint) {
    let auxiliaryLabel = UILabel(frame: label.frame)
    auxiliaryLabel.text = text
    auxiliaryLabel.font = label.font
    auxiliaryLabel.textAlignment = label.textAlignment
    auxiliaryLabel.textColor = label.textColor
    auxiliaryLabel.backgroundColor = .clear
    auxiliaryLabel.transform = CGAffineTransform(translationX: offset.x, y: offset.y)
    auxiliaryLabel.alpha = 0
    view.addSubview(auxiliaryLabel)

    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
      label.transform = CGAffineTransform(translationX: offset.x, y: offset.y)
      label.alpha = 0
    }
    UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseIn, animations: {
      auxiliaryLabel.transform = .identity
      auxiliaryLabel.alpha = 1
    }, completion: { _ in
      auxiliaryLabel.removeFromSuperview()
      label.text = text
      label.alpha = 1
      label.transform = .identity
    })
  }
}
