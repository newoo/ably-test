//
//  LikeButton.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/13.
//

import UIKit

class LikeButton: UIButton {
  private(set) var isLiked = false
  
  init(isLiked: Bool = false) {
    self.isLiked = isLiked
    super.init(frame: .zero)
    setImage(UIImage(named: "like-unselected"), for: .normal)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setLike(to isLiked: Bool) {
    self.isLiked = isLiked
    let image = UIImage(named: isLiked ? "like-selected" :"like-unselected")
    setImage(image, for: .normal)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    setLike(to: !isLiked)
    super.touchesEnded(touches, with: event)
  }
}
