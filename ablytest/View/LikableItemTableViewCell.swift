//
//  LikableItemTableViewCell.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/12.
//

import UIKit
import SnapKit
import RxSwift

class LikableItemTableViewCell: ItemTableViewCell {
  private let likeButton: LikeButton
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    likeButton = LikeButton()
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(likeButton)
    likeButton.snp.makeConstraints {
      $0.top.equalTo(thumbnailImageView.snp.top).offset(8)
      $0.trailing.equalTo(thumbnailImageView.snp.trailing).offset(-8)
      $0.width.height.equalTo(24)
    }
    
    itemInput.compactMap { $0.isLiked }
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] in
        self?.likeButton.setLike(to: $0)
      })
      .disposed(by: disposeBag)
    
    Observable.combineLatest(
      likeButton.rx.tap.asObservable(),
      itemInput,
      resultSelector: {
        return $1
      }).subscribe(onNext: { [weak self] item in
        var likedItems = self?.getLikedItems() ?? []
        likedItems = self?.adjustLikedItems(likedItems, with: item) ?? []
        self?.setLikedItems(likedItems)
      }).disposed(by: disposeBag)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func getLikedItems() -> [Item] {
    guard let data = UserDefaults.standard.value(forKey: "likes") as? Data,
       let likeditems = try? PropertyListDecoder().decode([Item].self, from: data) else {
      return []
    }
     
    return likeditems
  }
  
  private func setLikedItems(_ items: [Item]) {
    UserDefaults.standard.set(try? PropertyListEncoder().encode(items), forKey: "likes")
    UserDefaults.standard.synchronize()
  }
  
  private func adjustLikedItems(_ items: [Item], with item: Item) -> [Item] {
    guard likeButton.isLiked else {
      return items.filter { $0.id != item.id }
    }
    
    var items = items
    
    if !(items.contains { $0.id == item.id }) {
      items.append(item)
    }
    
    return items
  }
}
