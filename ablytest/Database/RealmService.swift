//
//  RealmService.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/15.
//

import RealmSwift
import RxSwift

class RealmService {
  static let shared = RealmService()
  
  private let realm: Realm
  
  private init() {
    guard let realm = try? Realm() else {
      fatalError("Realm 초기화 실패")
    }
    
    self.realm = realm
  }
  
  func fetch<T: Object>(object type: T.Type) -> [T] {
    self.realm.objects(type).map({ $0 })
  }
  
  func write<T: Object>(object: T) {
    do {
      try realm.write {
        realm.add(object, update: .all)
      }
    } catch {
      print("realm 객체 생성 실패")
    }
  }
  
  func delete<T: Object>(object: T, by primaryKey: Int) {
    do {
      if let object = realm.object(ofType: type(of: object), forPrimaryKey: primaryKey) {
        try realm.write {
          realm.delete(object)
        }
      }
    } catch {
      print("realm 객체 삭제 실패")
    }
  }
  
  func handle<T: Object>(object: T, by primaryKey: Int) {
    if let object = realm.object(ofType: type(of: object), forPrimaryKey: primaryKey) {
      delete(object: object, by: primaryKey)
      return
    }

    write(object: object)
  }
}
