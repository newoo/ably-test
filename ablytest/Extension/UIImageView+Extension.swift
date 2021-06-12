//
//  UIImageView+Extension.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/12.
//

import UIKit
import RxSwift
import RxCocoa

extension UIImageView {
  func load(with path: String) {
    guard !path.isEmpty, let url = URL(string: path) else {
      return
    }
    
    sd_setImage(with: url, placeholderImage: nil)
  }
}

extension Reactive where Base: UIImageView {
  var imageURL: Binder<String> {
    return Binder(self.base) { imageView, path in
      imageView.load(with: path)
    }
  }
}
