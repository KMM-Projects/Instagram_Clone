//
//  MainTabBarController.swift
//  Instgram_Clone_FireBase
//
//  Created by Patrik Kemeny on 7/7/18.
//  Copyright © 2018 Patrik Kemeny. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
//        let redVC = UIViewController()
//        redVC.view.backgroundColor = .red

        let layout = UICollectionViewLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let navController = UINavigationController(rootViewController: userProfileController)
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = .black
        viewControllers = [navController, UIViewController()]
    }
}
