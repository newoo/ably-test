//
//  BannerCollectionViewCell.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/14.
//

import UIKit
import SnapKit
import RxSwift

class BannerCollectionViewCell: UICollectionViewCell {
  static let identifier = "BannerCollectionViewCell"
  
  private let imageView = UIImageView()
  
  let bannerInput = PublishSubject<Banner>()
  
  var disposeBag = DisposeBag()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)
    
    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    bannerInput.map { $0.image }
      .observeOn(MainScheduler.instance)
      .bind(to: imageView.rx.imageURL)
      .disposed(by: disposeBag)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
