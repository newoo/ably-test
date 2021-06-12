//
//  ItemFixture.swift
//  ablytestTests
//
//  Created by Taeheon Woo on 2021/06/12.
//

import Foundation
@testable import ablytest

struct ItemFixture {
  static let item1: Item = fixture([
    "actual_price": 18000,
    "id": 1,
    "image": "https://d20s70j9gw443i.cloudfront.net/t_GOODS_THUMB_WEBP/https://imgb.a-bly.com/data/goods/20210122_1611290798811044s.jpg",
    "is_new": false,
    "name": "반팔 가디건",
    "price": 16000,
    "sell_count": 61
  ])
}
