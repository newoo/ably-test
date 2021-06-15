//
//  HomeViewReactorSpec.swift
//  ablytestTests
//
//  Created by Taeheon Woo on 2021/06/12.
//

import Quick
import Nimble
import Moya
import RxSwift
import RxBlocking
@testable import ablytest

class HomeViewReactorSpec: QuickSpec {
  override func spec() {
    describe("HomeViewReactor") {
      var homeViewReactor: HomeViewReactor!
      
      beforeEach {
        let networking = Networking<AblyAPI>(stubClosure: MoyaProvider.immediatelyStub)
        homeViewReactor = HomeViewReactor(networking: networking)
      }
      
      context("with enter action") {
        beforeEach {
          homeViewReactor.action.onNext(.enter)
        }
        
        it("reduce item list") {
          let blocking = homeViewReactor.state
            .map { $0.items }
            .toBlocking()
          let items = try? blocking.first()
          
          expect(items?.isEmpty).toEventuallyNot(beTrue(),
                                                 timeout: .seconds(3))
        }
        
        it("reduce banner") {
          let blocking = homeViewReactor.state
            .map { $0.banners }
            .toBlocking()
          let banners = try? blocking.first()
          
          expect(banners?.isEmpty).toEventuallyNot(beTrue(),
                                                   timeout: .seconds(3))
        }
      }
    }
  }
}
