//
//  ListViewController.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/14.
//

import UIKit

class ListViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavigationBar()
  }
  
  func setNavigationBarTitle(_ title: String) {
    navigationItem.title = title
  }
  
  private func setNavigationBar() {
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barTintColor = Color.Background.navigationBar
  }
}
