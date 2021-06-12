//
//  Fixture.swift
//  ablytestTests
//
//  Created by Taeheon Woo on 2021/06/12.
//

import Foundation

func fixture<T: Decodable>(_ json: [String: Any?]) -> T {
  do {
    let data = try JSONSerialization.data(withJSONObject: json.compactMapValues{ $0 },
                                          options: [])
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try decoder.decode(T.self, from: data)
  } catch let error {
    fatalError(String(describing: error))
  }
}
