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

class HomeViewController: ListViewController, View {
  typealias Reactor = HomeViewReactor
  
  private let collectionView: UICollectionView = {
    let width = UIScreen.main.bounds.size.width
    let height = width / 375 * 263
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width: width, height: height)
    layout.minimumLineSpacing = 0
    
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
    collectionView.decelerationRate = .normal
    collectionView.register(BannerCollectionViewCell.self,
                            forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
    
    return collectionView
  }()
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 160
    tableView.register(LikableItemTableViewCell.self,
                       forCellReuseIdentifier: LikableItemTableViewCell.identifier)
    
    return tableView
  }()
  
  private let bannerCountLabel: UILabel = {
    let label = UILabel()
    label.layer.cornerRadius = 12.5
    label.layer.masksToBounds = true
    label.backgroundColor = Color.Background.bannerCount
    label.textColor = .white
    label.font = .systemFont(ofSize: 13)
    label.textAlignment = .center
    
    return label
  }()
  
  fileprivate var bannerPosition: Int {
    let width = UIScreen.main.bounds.size.width
    let proportionalOffset = collectionView.contentOffset.x / width
    let index = Int(round(proportionalOffset))
    let numberOfItems = collectionView.numberOfItems(inSection: 0)
    let safeIndex = max(0, min(numberOfItems - 1, index))
    return safeIndex
  }
  
  private let refreshControl = UIRefreshControl()
  
  private var isPaging: Bool = false
  
  var disposeBag = DisposeBag()
  
  // MARK: - Initializer
  init(reactor: HomeViewReactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
  }
  
  required init?(coder: NSCoder) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = HomeViewReactor() 
  }
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavigationBarTitle("홈")
    setConstraints()
    reactor?.action.onNext(.enter)
  }
  
  // MARK: - Set layout
  private func setConstraints() {
    addSubviews()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func addSubviews() {
    view.addSubview(tableView)
    
    tableView.refreshControl = refreshControl
  }
  
  // MARK: - Binding
  func bind(reactor: HomeViewReactor) {
    reactor.state
      .map { $0.items }
      .do(onNext: { [weak self] _ in
        self?.refreshControl.endRefreshing()
        self?.itemListStopPaging()
      }).bind(to: tableView.rx.items(
        cellIdentifier: LikableItemTableViewCell.identifier,
        cellType: LikableItemTableViewCell.self
      )) { _, item, cell in
        cell.itemInput.onNext(item)
      }.disposed(by: disposeBag)
    
    reactor.state
      .map { $0.banners }
      .filter { !$0.isEmpty }
      .observeOn(MainScheduler.asyncInstance)
      .do(onNext: { [weak self] in
        self?.tableView.tableHeaderView = nil
        self?.tableView.tableHeaderView
          = self?.createBannerHeaderView(with: $0)
      })
      .bind(to: collectionView.rx.items(
        cellIdentifier: BannerCollectionViewCell.identifier,
        cellType: BannerCollectionViewCell.self
      )) { _, item, cell in
        cell.bannerInput.onNext(item)
      }.disposed(by: disposeBag)
    
    tableView.rx.didScroll
      .bind(to: self.rx.itemListDidScroll)
      .disposed(by: disposeBag)
    
    collectionView.rx.willEndDragging
      .bind(to: self.rx.bannerWillEndDragged)
      .disposed(by: disposeBag)
    
    refreshControl.rx.controlEvent(.valueChanged)
      .delay(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] in
        self?.reactor?.action.onNext(.enter)
      }).disposed(by: disposeBag)
  }
  
  // MARK: Create header & footer
  private func createBannerHeaderView(with banner: [Banner]) -> UIView {
    let width = UIScreen.main.bounds.size.width
    let height = width / 375 * 263
    
    let headerView = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: width,
                                          height: height))
    headerView.addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    collectionView.scrollToItem(at: IndexPath(item: 0, section: 0),
                                at: .centeredHorizontally,
                                animated: false)
    
    headerView.addSubview(bannerCountLabel)
    bannerCountLabel.snp.makeConstraints {
      $0.trailing.bottom.equalToSuperview().inset(16)
      $0.width.equalTo(48)
      $0.height.equalTo(24)
    }
    
    bannerCountLabel.text = "1/\(banner.count)"
    
    return headerView
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
  
  // MARK: - Handle scroll
  fileprivate func itemListDidScroll() {
    let offsetY = tableView.contentOffset.y
    let contentHeight = tableView.contentSize.height
    let height = tableView.frame.height
    
    guard offsetY > 0.0, offsetY > (contentHeight - height), !isPaging else {
      return
    }
    
    itemListBeginPaging()
  }
  
  private func itemListBeginPaging() {
    isPaging = true
    
    DispatchQueue.main.async {
      self.tableView.tableFooterView = self.createSpinnerFooter()
      self.reactor?.action.onNext(.loadMore)
    }
  }
  
  private func itemListStopPaging() {
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
  
  fileprivate func handleBannerScroll(velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    targetContentOffset.pointee = collectionView.contentOffset
    
    let indexPath = IndexPath(row: bannerPosition, section: 0)
    collectionView.scrollToItem(at: indexPath,
                                at: .centeredHorizontally,
                                animated: true)
    self.bannerCountLabel.text
      = "\(self.bannerPosition + 1)/\(collectionView.numberOfItems(inSection: 0))"
  }
}

// MARK: - Reactive Extension
fileprivate extension Reactive where Base: HomeViewController {
  var itemListDidScroll: Binder<Void> {
    return Binder(self.base) { base, _ in
      base.itemListDidScroll()
    }
  }
  
  var bannerWillEndDragged: Binder<(velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)> {
    return Binder(self.base) { base, dragEvent in
      base.handleBannerScroll(velocity: dragEvent.velocity, targetContentOffset: dragEvent.targetContentOffset)
    }
  }
}
