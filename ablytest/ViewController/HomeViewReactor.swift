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
    case setBanners([Banner])
    case setItems([Item])
    case appendItems([Item])
  }
  
  struct State {
    var isLoading = false
    var banners = [Banner]()
    var items = [Item]()
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
      return networking.request(.home)
        .asObservable()
        .map { [weak self] response -> Response in
          let items: [Item] = response.goods.map { item in
            if self?.currentState.likedItems.contains(where: { $0 == item.id }) == true {
              var item = item
              item.setLike(to: true)
              return item
            }
            
            return item
          }
          
          return Response(banners: response.banners, goods: items)
        }.map { response -> [Mutation] in
          [.setLoading(true),
           .setBanners(response.banners ?? []),
           .setItems(response.goods),
           .setLoading(false)]
        }.flatMap { Observable.from($0) }
      
    case .loadMore:
      let lastId = currentState.items.last?.id
      let appendItems = networking.request(.goods(lastId))
        .asObservable()
        .map { $0.goods }
        .map { Mutation.appendItems($0) }
      
      return .concat([.just(.setLoading(true)),
                      appendItems,
                      .just(.setLoading(false))])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    
    switch mutation {
    case let .setLoading(isLoading):
      state.isLoading = isLoading
      
    case let .setBanners(banners):
      state.banners = banners
      
    case let .setItems(items):
      state.items = items
      
    case let .appendItems(items):
      state.items.append(contentsOf: items)
    }
    
    return state
  }
}
