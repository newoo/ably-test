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
  
  private var isPaging: Bool = false
  
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
    navigationItem.title = "홈"
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barTintColor = Color.navigationBarBackgroundColor
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
  
  func bind(reactor: HomeViewReactor) {
    reactor.state
      .map { $0.items }
      .do(onNext: { [weak self] _ in
        self?.stopPaging()
      }).bind(to: tableView.rx.items(
        cellIdentifier: ItemTableViewCell.identifier,
        cellType: ItemTableViewCell.self
      )) { _, item, cell in
        cell.itemInput.onNext(item)
      }.disposed(by: disposeBag)
    
    tableView.rx.didScroll
      .bind(to: self.rx.didScroll)
      .disposed(by: disposeBag)
  }
  
  fileprivate func didScroll() {
    let offsetY = tableView.contentOffset.y
    let contentHeight = tableView.contentSize.height
    let height = tableView.frame.height
    
    guard offsetY > 0.0, offsetY > (contentHeight - height), !isPaging else {
      return
    }
    
    beginPaging()
  }
  
  private func beginPaging() {
    isPaging = true
    
    DispatchQueue.main.async {
      self.tableView.tableFooterView = self.createSpinnerFooter()
      self.reactor?.action.onNext(.loadMore)
    }
  }
  
  fileprivate func stopPaging() {
    guard self.tableView.tableFooterView != nil else {
      return
    }
    
    let lastRowIndex = self.tableView.numberOfRows(inSection: 0)
    
    tableView.tableFooterView = nil
    tableView.scrollToRow(at: IndexPath(row: lastRowIndex - 1, section: 0),
                          at: .bottom,
                          animated: true)
    isPaging = false
  }
  
  private func createSpinnerFooter() -> UIView {
    let footerView = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.frame.size.width,
                                          height: 100))
    let spinner = UIActivityIndicatorView()
    spinner.center = footerView.center
    footerView.addSubview(spinner)
    
    spinner.startAnimating()
    
    return footerView
  }
}

fileprivate extension Reactive where Base: HomeViewController {
  var didScroll: Binder<Void> {
    return Binder(self.base) { base, _ in
      base.didScroll()
    }
  }
}
