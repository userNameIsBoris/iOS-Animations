//
//  ViewController.swift
//  PackingList
//
//  Created by Boris Ezhov on 28.09.2021.
//

import UIKit

final class ViewController: UIViewController {
  @IBOutlet private var tableView: UITableView!
  @IBOutlet private var buttonMenu: UIButton!
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var menuHeightConstraint: NSLayoutConstraint!

  private var slider: HorizontalItemList!
  private var isMenuOpen = false
  private var items = [5, 6, 7]
  let itemTitles = [
    "Icecream money",
    "Great weather",
    "Beach ball",
    "Swim suit for him",
    "Swim suit for her",
    "Beach games",
    "Ironing board",
    "Cocktail mood",
    "Sunglasses",
    "Flip flops",
  ]

  // MARK: - Methods
  @IBAction private func actionToggleMenu(_ sender: AnyObject) {
    isMenuOpen.toggle()
    titleLabel.superview?.constraints.forEach { constraint in
      if constraint.firstItem === titleLabel && constraint.firstAttribute == .centerX {
        constraint.constant = isMenuOpen ? -100 : 0
        return
      }
      if constraint.identifier == "TitleCenterY" {
        constraint.isActive = false
        let multiplier = isMenuOpen ? 0.67 : 1
        let newConstraint = NSLayoutConstraint(
          item: titleLabel!,
          attribute: .centerY,
          relatedBy: .equal,
          toItem: titleLabel.superview,
          attribute: .centerY,
          multiplier: multiplier,
          constant: 0)
        newConstraint.identifier = constraint.identifier
        newConstraint.isActive = true
        return
      }
    }
    menuHeightConstraint.constant = isMenuOpen ? 184 : 44
    titleLabel.text = isMenuOpen ? "Select Item" : "Packing List"
    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10) {
      self.view.layoutIfNeeded()
      let angle = self.isMenuOpen ? CGFloat.pi / 4 : 0
      self.buttonMenu.transform = CGAffineTransform(rotationAngle: angle)
    }
    if isMenuOpen {
      slider = HorizontalItemList(inView: view)
      slider.didSelectItem = { index in
        print("add \(index)")
        self.items.append(index)
        self.tableView.reloadData()
        self.actionToggleMenu(self)
      }
      self.titleLabel.superview!.addSubview(slider)
      print(titleLabel.superview == view)
    } else {
      slider.removeFromSuperview()
    }
  }
  
  private func showItem(_ index: Int) {
    let image = UIImage(named:"summericons_100px_0\(index)")
    let imageView = UIImageView(image: image)
    imageView.backgroundColor = UIColor(white: 0, alpha: 0.5)
    imageView.layer.cornerRadius = 5
    imageView.layer.masksToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(imageView)

    let constraints = [
      imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
    ]
    let bottomConstraint = imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: imageView.frame.height)
    let widthConstraint = imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.33, constant: -50)
    NSLayoutConstraint.activate(constraints + [bottomConstraint, widthConstraint])

    view.layoutIfNeeded()
    UIView.animateKeyframes(withDuration: 2.4, delay: 0, animations: {
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.33) {
        bottomConstraint.constant = -imageView.frame.size.height / 2
        widthConstraint.constant = 0
        self.view.layoutIfNeeded()
      }
      UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.33) {
        bottomConstraint.constant = imageView.frame.height
        widthConstraint.constant = -50
        self.view.layoutIfNeeded()
      }
    }, completion: { _ in
      imageView.removeFromSuperview()
    })
  }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView?.rowHeight = 54
  }
  
  // MARK: - Table View Data Source
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
    cell.accessoryType = .none
    cell.textLabel?.text = itemTitles[items[indexPath.row]]
    cell.imageView?.image = UIImage(named: "summericons_100px_0\(items[indexPath.row])")
    return cell
  }

  // MARK: - Table View Delegates
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let item = items[indexPath.row]
    showItem(item)
  }
}
