//
//  Color.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/12.
//

import UIKit

struct Color {
  static let ablyRed = UIColor(red: CGFloat(255.0/255.0),
                               green: CGFloat(81.0/255.0),
                               blue: CGFloat(96.0/255.0),
                               alpha: 1.0)
  
  static let ablyBlack = UIColor(red: CGFloat(31.0/255.0),
                                 green: CGFloat(31.0/255.0),
                                 blue: CGFloat(31.0/255.0),
                                 alpha: 1.0)
  
  static let ablyGray = UIColor(red: CGFloat(119.0/255.0),
                                green: CGFloat(119.0/255.0),
                                blue: CGFloat(119.0/255.0),
                                alpha: 1.0)
  
  struct Background {
    static let navigationBar = UIColor(red: CGFloat(248.0/255.0),
                                       green: CGFloat(248.0/255.0),
                                       blue: CGFloat(248.0/255.0),
                                       alpha: 0.82)
    
    static let bannerCount = UIColor(red: CGFloat(0.0/255.0),
                                     green: CGFloat(0.0/255.0),
                                     blue: CGFloat(0.0/255.0),
                                     alpha: 0.2)
  }
}
