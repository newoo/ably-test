//
//  HomeViewReactor.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/12.
//

import RxSwift
import ReactorKit

final class HomeViewReactor: Reactor {
  enum Action {
    case enter
    case loadMore
  }
  
  enum Mutation {
    case setLoading(Bool)
    case setItems([Item])
  }
  
  struct State {
    var items = [Item]()
    var isLoading = false
    var likedItems : [UInt] = {
      guard let data = UserDefaults.standard.value(forKey: "likes") as? Data,
            let likeditems = try? PropertyListDecoder().decode([Item].self, from: data) else {
        return []
      }
      
      return likeditems.map { $0.id }
    }()
  }
  
  let initialState = State()
  
  var disposeBag = DisposeBag()
  
  let networking: Networking<AblyAPI>
  
  init(networking: Networking<AblyAPI> = .init()) {
    self.networking = networking
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .enter:
      let setItems = networking.request(.home)
        .asObservable()
        .map { $0.goods }
        .map { [weak self] items in
          return items.map { item in
            if self?.currentState.likedItems.contains(where: { $0 == item.id }) == true {
              var item = item
              item.setLike(to: true)
              return item
            }
            
            return item
          }
        }
        .map { Mutation.setItems($0) }
      
      return .concat([.just(.setLoading(true)),
                      setItems,
                      .just(.setLoading(false))])
      
    case .loadMore:
      let lastId = currentState.items.last?.id
      let setItems = networking.request(.goods(lastId))
        .asObservable()
        .map { $0.goods }
        .map { Mutation.setItems($0) }
      
      return .concat([.just(.setLoading(true)),
                      setItems,
                      .just(.setLoading(false))])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    
    switch mutation {
    case let .setLoading(isLoading):
      state.isLoading = isLoading
      
    case let .setItems(items):
      state.items = state.items + items
    }
    
    return state
  }
}
