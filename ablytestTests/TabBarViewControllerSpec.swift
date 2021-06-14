//
//  TabBarViewControllerSpec.swift
//  ablytestTests
//
//  Created by Taeheon Woo on 2021/06/14.
//

import Quick
import Nimble
@testable import ablytest

class TabBarViewControllerSpec: QuickSpec {
  override func spec() {
    describe("TabbarViewController") {
      var tabBarViewController: TabBarViewController!
      
      beforeEach {
        tabBarViewController = TabBarViewController()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = tabBarViewController
        
        tabBarViewController.beginAppearanceTransition(true, animated: false)
        tabBarViewController.endAppearanceTransition()
      }
      
      it("renders 2 tab bar items") {
        let tabBarItems = tabBarViewController.tabBar.items
        
        expect(tabBarItems?.count).to(equal(2))
        expect(tabBarItems?.first?.title).to(equal("홈"))
        expect(tabBarItems?.last?.title).to(equal("좋아요"))
      }
    }
  }
}
