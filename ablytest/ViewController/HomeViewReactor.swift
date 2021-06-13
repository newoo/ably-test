//
//  HomeViewReactor.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/12.
//

import RxSwift
import ReactorKit
import Moya

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
