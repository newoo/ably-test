//
//  AblyAPI.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/12.
//

import Moya
import MoyaSugar

enum AblyAPI: SugarTargetType {
  case home
  
  var baseURL: URL {
    return URL(string: "http://d2bab9i9pr8lds.cloudfront.net/api")!
  }
  
  var route: Route {
    switch self {
    case .home:
      return .get("/home")
    }
  }
  
  var parameters: Parameters? {
    nil
  }
  
  var headers: [String: String]? {
    return ["Accept": "application/json"]
  }
  
  var sampleData: Data {
    func stub(_ fileName: String) -> Data {
      guard let path = Bundle.main.path(forResource: fileName, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
        return Data()
      }
      
      return data
    }
    
    switch self {
    case .home:
      return stub("HomeResponse")
    }
  }
}
