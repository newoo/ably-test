//
//  ItemTableViewCellSpec.swift
//  ablytestTests
//
//  Created by Taeheon Woo on 2021/06/12.
//

import Quick
import Nimble
@testable import ablytest

class ItemTableViewCellSpec: QuickSpec {
  override func spec() {
    describe("ItemTableViewCell") {
      var itemTableViewCell: ItemTableViewCell!
      var imageView: UIImageView!
      var likeButton: LikeButton!
      var verticalStackView: UIStackView!
      var priceStackView: UIStackView!
      var statusStackView: UIStackView!
      
      beforeEach {
        itemTableViewCell = ItemTableViewCell()
        
        imageView = itemTableViewCell.contentView.subviews.compactMap { $0 as? UIImageView }.first!
        likeButton = itemTableViewCell.contentView.subviews.compactMap { $0 as? LikeButton }.first!
        verticalStackView = itemTableViewCell.contentView.subviews.compactMap { $0 as? UIStackView }.first!
        priceStackView = verticalStackView.arrangedSubviews.first as? UIStackView
        statusStackView = verticalStackView.arrangedSubviews.last as? UIStackView
      }
      
      context("with item data") {
        beforeEach {
          itemTableViewCell.itemInput.onNext(ItemFixture.item)
        }
        
        it ("renders item image") {
          expect(imageView.image).toNotEventually(beNil())
        }
        
        it("renders unselected like image") {
          expect(likeButton.image(for: .normal)).to(equal(UIImage(named: "like-unselected")))
        }
        
        it("renders price") {
          let priceLabel = priceStackView.arrangedSubviews.last as? UILabel
          expect(priceLabel?.text).to(equal("16,000"))
        }
        
        it("renders discount") {
          let discountLabel = priceStackView.arrangedSubviews.first as? UILabel
          expect(discountLabel?.text).to(equal("12%"))
        }
        
        it("renders title") {
          let nameLabel = verticalStackView.arrangedSubviews[1] as? UILabel
          expect(nameLabel?.text).to(equal("반팔 가디건"))
        }
        
        it("renders sell count") {
          let sellCountLabel = statusStackView.arrangedSubviews.last as? UILabel
          expect(sellCountLabel?.text).to(equal("61개 구매중"))
        }
        
        it("renders new tag") {
          let newTagImageView = statusStackView.arrangedSubviews.first as? UIImageView
          expect(newTagImageView?.image).to(equal(UIImage(named: "new-badge")))
        }
        
        context("when item is liked") {
          beforeEach {
            var item = ItemFixture.item
            item.setLike(to: true)
            
            itemTableViewCell.itemInput.onNext(item)
          }

          it("renders selected like image") {
            expect(likeButton.image(for: .normal)).to(equal(UIImage(named: "like-selected")))
          }
        }
      }
    }
  }
}
