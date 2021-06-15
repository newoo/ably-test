//
//  ItemObject.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/15.
//

import RealmSwift

class ItemObject: Object, Codable {
  @objc dynamic var id: Int = 0
  @objc dynamic var name: String = ""
  @objc dynamic var image: String = ""
  @objc dynamic var actualPrice: Int = 0
  @objc dynamic var price: Int = 0
  @objc dynamic var isNew: Bool = false
  @objc dynamic var sellCount: Int = 0
  
  enum CodingKeys: String, CodingKey {
    case id, name, image, price
    case actualPrice = "actual_price"
    case isNew = "is_new"
    case sellCount = "sell_count"
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
}
