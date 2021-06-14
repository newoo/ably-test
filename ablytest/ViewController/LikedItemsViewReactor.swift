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
    case setLoading(Bool)
    case setLikedItems([Item])
  }
  
  struct State {
    var isLoading = false
    var likedItems = [Item]()
  }
  
  let initialState = State()
  
  var disposeBag = DisposeBag()
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .enter:
      let likeditems: [Item] = {
        guard let data = UserDefaults.standard.value(forKey: "likes") as? Data,
              let likeditems = try? PropertyListDecoder().decode([Item].self, from: data) else {
          return []
        }
        
        return likeditems
      }()
      
      return .concat([.just(.setLoading(true)),
                      .just(.setLikedItems(likeditems)),
                      .just(.setLoading(false))])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    
    switch mutation {
    case let .setLoading(isLoading):
      state.isLoading = isLoading
      
    case let .setLikedItems(items):
      state.likedItems = state.likedItems + items
    }
    
    return state
  }
}

