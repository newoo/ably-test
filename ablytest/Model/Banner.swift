//
//  Banner.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/14.
//

struct Banner: Decodable {
  let id: UInt
  let image: String
  
  enum CodingKeys: String, CodingKey {
    case id, image
  }
}
