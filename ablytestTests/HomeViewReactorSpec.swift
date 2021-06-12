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
        it("reduce item list") {
          homeViewReactor.action.onNext(.enter)
          let obs = homeViewReactor.state.map { $0.items }.toBlocking()
          let items = try? obs.first()
          
          expect(items?.isEmpty).toEventuallyNot(beTrue(), timeout: .seconds(3))
        }
      }
    }
  }
  
}
