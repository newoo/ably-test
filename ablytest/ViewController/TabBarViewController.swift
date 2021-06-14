//
//  TabBarViewController.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/14.
//

import UIKit

class TabBarViewController: UITabBarController {
  let homeViewController: UINavigationController = {
    let viewController = HomeViewController(reactor: HomeViewReactor())
    let navigationViewController = UINavigationController(rootViewController: viewController)
    
    navigationViewController.tabBarItem
      = UITabBarItem(title: "홈",
                     image: UIImage(named: "home-unselected"),
                     selectedImage: UIImage(named: "home-selected"))
    
    return navigationViewController
  }()
  
  let likedItemsViewController: UINavigationController = {
    let viewController = LikedItemsViewController(reactor: LikedItemsViewReactor())
    let navigationViewController = UINavigationController(rootViewController: viewController)
    
    navigationViewController.tabBarItem
      = UITabBarItem(title: "좋아요",
                     image: UIImage(named: "like-unselected"),
                     selectedImage: UIImage(named: "like-selected"))
    
    return navigationViewController
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tabBar.tintColor = Color.ablyRed
    tabBar.barTintColor = .white
    tabBar.isTranslucent = false
    viewControllers = [homeViewController, likedItemsViewController]
  }
}
