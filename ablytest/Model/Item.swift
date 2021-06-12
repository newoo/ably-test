//
//  Item.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/12.
//

struct Item: Decodable {
  let id: UInt
  let name: String
  let image: String
  let actualPrice: UInt
  let price: UInt
  let isNew: Bool
  let sellCount: UInt
  
  var discount: UInt {
    100 - (price * 100 / actualPrice)
  }
  
  var discountText: String {
    discount > 0 ? "\(discount)%" : ""
  }
  
  var sellCountText: String {
    sellCount >= 10 ? sellCount.decimalText + "개 구매중" : ""
  }
  
  var actualImagePath: String? {
    image.components(separatedBy: "GOODS_THUMB_WEBP/").last
  }
  
  enum CodingKeys: String, CodingKey {
    case id, name, image, price
    case actualPrice = "actual_price"
    case isNew = "is_new"
    case sellCount = "sell_count"
  }
}
