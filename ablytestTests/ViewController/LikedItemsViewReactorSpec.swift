//
//  LikedItemsViewReactorSpec.swift
//  ablytestTests
//
//  Created by Taeheon Woo on 2021/06/14.
//

import Quick
import Nimble
import Moya
import RxSwift
import RxBlocking
@testable import ablytest

class LikedItemsViewReactorSpec: QuickSpec {
  override func spec() {
    describe("LikedItemsViewReactor") {
      var likedItemsViewReactor: LikedItemsViewReactor!
      
      beforeEach {
        likedItemsViewReactor = LikedItemsViewReactor()
      }
      
      context("with enter action") {
        beforeEach {
          likedItemsViewReactor.action.onNext(.enter)
        }
        
        it("reduce item list") {
          let blocking = likedItemsViewReactor.state.map { $0.likedItems }.toBlocking()
          let items = try? blocking.first()
          
          expect(items?.isEmpty).toEventuallyNot(beTrue(), timeout: .seconds(3))
        }
      }
    }
  }
}

