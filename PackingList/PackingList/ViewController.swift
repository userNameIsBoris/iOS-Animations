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
    menuHeightConstraint.constant = isMenuOpen ? 184 : 44
    titleLabel.text = isMenuOpen ? "Select Item" : "Packing List"
    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10) {
      self.view.layoutIfNeeded()
      let angle = self.isMenuOpen ? CGFloat.pi / 4 : 0
      self.buttonMenu.transform = CGAffineTransform(rotationAngle: angle)
    }
  }
  
  private func showItem(_ index: Int) {
    print("tapped item \(index)")
  }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView?.rowHeight = 54.0
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
    cell.imageView?.image = UIImage(named: "summericons_100px_0\(items[indexPath.row]).png")
    return cell
  }

  // MARK: - Table View Delegates
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let item = items[indexPath.row]
    showItem(item)
  }
}
