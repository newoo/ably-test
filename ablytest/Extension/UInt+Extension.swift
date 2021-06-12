//
//  UInt+Extension.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/12.
//
import Foundation

extension UInt {
  var decimalText: String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    return numberFormatter.string(from: NSNumber(value: self)) ?? ""
  }
}
