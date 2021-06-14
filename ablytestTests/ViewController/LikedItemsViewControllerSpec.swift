//
//  LikedItemsViewControllerSpec.swift
//  ablytestTests
//
//  Created by Taeheon Woo on 2021/06/14.
//

import Quick
import Nimble
@testable import ablytest

class LikedItemsViewControllerSpec: QuickSpec {
  override func spec() {
    describe("LikedItemsViewController") {
      var likedItemsViewController: LikedItemsViewController!
      
      beforeEach {
        likedItemsViewController = LikedItemsViewController()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = likedItemsViewController
        
        likedItemsViewController.beginAppearanceTransition(true, animated: false)
        likedItemsViewController.endAppearanceTransition()
      }
      
      context("when did appeared") {
        it("renders title") {
          expect(likedItemsViewController.navigationItem.title) == "좋아요"
        }
        
        it("renders liked item list") {
          let tableView = likedItemsViewController.view.subviews.first { $0 is UITableView } as? UITableView
          expect(tableView).notTo(beNil())
          expect(tableView?.visibleCells.isEmpty == false).to(beTrue())
        }
      }
    }
  }
}
