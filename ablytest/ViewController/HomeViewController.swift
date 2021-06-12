//
//  HomeViewController.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import ReactorKit

class HomeViewController: UIViewController, View {
  typealias Reactor = HomeViewReactor
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 160
    tableView.register(ItemTableViewCell.self,
                       forCellReuseIdentifier: ItemTableViewCell.identifier)
    
    return tableView
  }()
  
  var disposeBag = DisposeBag()
  
  init(reactor: HomeViewReactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
  }
  
  required init?(coder: NSCoder) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = HomeViewReactor() 
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setNavigationBar()
    setConstraints()
    reactor?.action.onNext(.enter)
  }
  
  private func setNavigationBar() {
    self.navigationItem.title = "홈"
  }
  
  private func setConstraints() {
    addSubviews()
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).inset(44)
      $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func addSubviews() {
    view.addSubview(tableView)
  }
  
  func bind(reactor: HomeViewReactor) {
    reactor.state
      .map { $0.items }
      .bind(to: tableView.rx.items(
        cellIdentifier: ItemTableViewCell.identifier,
        cellType: ItemTableViewCell.self
      )) { _, item, cell in
        cell.itemInput.onNext(item)
      }.disposed(by: disposeBag)
  }
}
