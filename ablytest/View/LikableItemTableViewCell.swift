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
    
    setConstraints()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setConstraints() {
    addSubviews()
    
    likeButton.snp.makeConstraints {
      $0.top.equalTo(thumbnailImageView.snp.top).offset(8)
      $0.trailing.equalTo(thumbnailImageView.snp.trailing).offset(-8)
      $0.width.height.equalTo(24)
    }
  }
  
  private func addSubviews() {
    contentView.addSubview(likeButton)
  }
  
  private func bind() {
    itemInput.compactMap { $0.isLiked }
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] in
        self?.likeButton.setLike(to: $0)
      })
      .disposed(by: disposeBag)
    
    Observable.combineLatest(
      likeButton.rx.tap.asObservable(),
      itemInput,
      resultSelector: { $1 }
    ).compactMap {
      Mapper.shared.convert(from: $0, to: ItemObject.self)
    }.subscribe(onNext: { itemObject in
      RealmService.shared.handle(object: itemObject,
                                 by: itemObject.id)
    }).disposed(by: disposeBag)
  }
}
