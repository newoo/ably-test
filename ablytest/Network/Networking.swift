//
//  Networking.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/12.
//

import Moya
import MoyaSugar
import RxSwift

final class Networking<Target: SugarTargetType>: MoyaSugarProvider<Target> {
  init(stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
       plugins: [PluginType] = []) {
    let session = MoyaProvider<Target>.defaultAlamofireSession()
    session.sessionConfiguration.timeoutIntervalForRequest = 10

    super.init(stubClosure: stubClosure, session: session, plugins: plugins)
  }

  func request(
    _ target: Target,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) -> Single<Response> {
    return self.rx.request(target)
      .map(Response.self)
  }
}
