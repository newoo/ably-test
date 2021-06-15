//
//  LikedItemsViewController.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import ReactorKit

class LikedItemsViewController: UIViewController, View {
  typealias Reactor = LikedItemsViewReactor
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 160
    tableView.register(ItemTableViewCell.self,
                       forCellReuseIdentifier: ItemTableViewCell.identifier)

    return tableView
  }()
  
  var disposeBag = DisposeBag()
  
  init(reactor: LikedItemsViewReactor = .init()) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
  }
  
  required init?(coder: NSCoder) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = LikedItemsViewReactor()
  }
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavigationBar()
    setConstraints()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    reactor?.action.onNext(.enter)
  }
  
  // MARK: - Set layout
  private func setNavigationBar() {
    navigationItem.title = "좋아요"
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barTintColor = Color.Background.navigationBar
  }
  
  private func setConstraints() {
    addSubviews()
    tableView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }

  private func addSubviews() {
    view.addSubview(tableView)
  }
  
  // MARK: - Binding
  func bind(reactor: LikedItemsViewReactor) {
    reactor.state
      .map { $0.likedItems }
      .bind(to: tableView.rx.items(
        cellIdentifier: ItemTableViewCell.identifier,
        cellType: ItemTableViewCell.self
      )) { _, item, cell in
        cell.itemInput.onNext(item)
      }.disposed(by: disposeBag)
  }
}
