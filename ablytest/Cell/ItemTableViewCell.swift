//
//  ItemTableViewCell.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/12.
//

import UIKit
import SnapKit
import RxSwift
import SDWebImage

class ItemTableViewCell: UITableViewCell {
  static let identifier = "ItemTableViewCell"
  
  private let thumbnailImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 4
    imageView.layer.masksToBounds = true
    
    return imageView
  }()
  
  private let discountLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 18)
    label.textColor = Color.discountRed
    label.setContentHuggingPriority(.required, for: .horizontal)
    
    return label
  }()
  
  private let priceLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 18)
    label.textColor = Color.ablyBlack
    
    return label
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = .systemFont(ofSize: 14)
    label.textColor = Color.ablyGray
    
    return label
  }()
  
  private let sellCountLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 13)
    label.textColor = Color.ablyGray
    
    return label
  }()
  
  private let newTagImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "new-badge")
    imageView.setContentHuggingPriority(.required, for: .horizontal)
    
    return imageView
  }()
  
  private var verticalStackView: UIStackView
  private let priceStackView: UIStackView
  private let statusStackView: UIStackView
  
  let itemInput = PublishSubject<Item>()
  
  var disposeBag = DisposeBag()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    priceStackView = UIStackView(arrangedSubviews: [discountLabel, priceLabel])
    statusStackView = UIStackView(
      arrangedSubviews: [newTagImageView, sellCountLabel])
    verticalStackView = UIStackView(
      arrangedSubviews: [priceStackView, nameLabel, statusStackView])
    
    super.init(style: style, reuseIdentifier: ItemTableViewCell.identifier)
    selectionStyle = .none
    setStackView()
    setConstraints()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setConstraints() {
    addSubviews()
    
    thumbnailImageView.snp.makeConstraints {
      $0.leading.equalTo(16)
      $0.top.equalTo(20)
      $0.width.height.equalTo(80)
    }
    
    verticalStackView.snp.makeConstraints {
      $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
      $0.top.bottom.equalToSuperview().inset(24)
      $0.trailing.equalToSuperview().inset(22)
    }
  }
  
  private func addSubviews() {
    self.addSubview(thumbnailImageView)
    self.addSubview(verticalStackView)
  }
  
  private func setStackView() {
    priceStackView.axis = .horizontal
    priceStackView.spacing = 5
    
    statusStackView.axis = .horizontal
    statusStackView.spacing = 4
    
    verticalStackView.axis = .vertical
    verticalStackView.spacing = 5
    verticalStackView.setCustomSpacing(17, after: nameLabel)
    verticalStackView.distribution = .fill
  }
  
  private func bind() {
    itemInput.compactMap {
      $0.image.components(separatedBy: "GOODS_THUMB_WEBP/").last
    }.bind(to: thumbnailImageView.rx.imageURL)
    .disposed(by: disposeBag)
    
    itemInput.map { $0.discountText }
      .do(onNext: { [weak self] in
        self?.priceStackView.spacing = $0.count > 0 ? 5 : 0
      }).observeOn(MainScheduler.instance)
      .bind(to: discountLabel.rx.text)
      .disposed(by: disposeBag)
    
    itemInput.map { $0.price.decimalText }
      .observeOn(MainScheduler.instance)
      .bind(to: priceLabel.rx.text)
      .disposed(by: disposeBag)
    
    itemInput.map { $0.name }
      .observeOn(MainScheduler.instance)
      .bind(to: nameLabel.rx.text)
      .disposed(by: disposeBag)
    
    itemInput.map { $0.sellCountText }
      .observeOn(MainScheduler.instance)
      .bind(to: sellCountLabel.rx.text)
      .disposed(by: disposeBag)
    
    itemInput.map { $0.isNew }
      .do(onNext: { [weak self] in
        self?.statusStackView.spacing = $0 ? 5 : 0
      }).map { !$0 }
      .observeOn(MainScheduler.instance)
      .bind(to: newTagImageView.rx.isHidden)
      .disposed(by: disposeBag)
  }
}
