//
//  ModelMapper.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/15.
//

import Foundation

class Mapper {
  static let shared = Mapper()
  
  private init() { }
  
  func convert<T: Codable, U: Codable>(from original: T, to new: U.Type) -> U? {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    guard let jsonData = try? encoder.encode(original),
          let jsonString = String(data: jsonData, encoding: .utf8),
          let data = jsonString.data(using: .utf8),
          let converted = try? decoder.decode(new.self, from: data) else {
      return nil
    }
    
    return converted
  }
}
