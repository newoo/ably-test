//
//  LikedItemsViewReactor.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/14.
//

import RxSwift
import ReactorKit

final class LikedItemsViewReactor: Reactor {
  enum Action {
    case enter
  }
  
  enum Mutation {
    case setLikedItems([Item])
  }
  
  struct State {
    var likedItems = [Item]()
  }
  
  let initialState = State()
  
  var disposeBag = DisposeBag()
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .enter:
      let likeditems: [Item] = {
        let itemObjects: [ItemObject] = RealmService.shared.fetch(object: ItemObject.self)
        return itemObjects
          .compactMap { Mapper.shared.convert(from: $0, to: Item.self) }
      }()
      
      return .just(.setLikedItems(likeditems))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    
    switch mutation {
    case let .setLikedItems(items):
      state.likedItems = items
    }
    
    return state
  }
}

