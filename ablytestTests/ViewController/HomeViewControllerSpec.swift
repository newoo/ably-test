//
//  HomeViewControllerSpec.swift
//  ablytestTests
//
//  Created by Taeheon Woo on 2021/06/12.
//

import Quick
import Nimble
import Moya
@testable import ablytest

class HomeViewControllerSpec: QuickSpec {
  override func spec() {
    describe("HomeViewController") {
      var homeViewController: HomeViewController!
      
      beforeEach {
        let networking = Networking<AblyAPI>(stubClosure: MoyaProvider.immediatelyStub)
        homeViewController = HomeViewController(reactor: HomeViewReactor(networking: networking))
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = homeViewController
        
        homeViewController.beginAppearanceTransition(true, animated: false)
        homeViewController.endAppearanceTransition()
      }
      
      context("when did appeared") {
        it("renders title") {
          expect(homeViewController.navigationItem.title) == "홈"
        }
        
        it("renders item list") {
          let tableView = homeViewController.view.subviews.first { $0 is UITableView } as? UITableView
          expect(tableView).notTo(beNil())
          expect(tableView?.visibleCells.isEmpty == false).to(beTrue())
        }
      }
    }
    
  }
}
