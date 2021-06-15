//
//  Response.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/12.
//

struct Response: Decodable {
  let banners: [Banner]?
  let goods: [Item]
  
  enum CodingKeys: String, CodingKey {
    case banners, goods
  }
}
