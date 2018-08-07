//
//  MainTabBarController.swift
//  Instgram_Clone_FireBase
//
//  Created by Patrik Kemeny on 7/7/18.
//  Copyright © 2018 Patrik Kemeny. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    //plus button reveals the photo bank
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //return index of the taped TabBAr Item
        let index = viewControllers?.index(of: viewController)
        //print(index) // Optional(1) OPtional(2) ....etc
        //to check the index see the view controller array below end of this script
        if index == 2 {
            
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            //before presenting we need the back and Cancel button to be hol on top of navigation controller
            let navController = UINavigationController(rootViewController: photoSelectorController)
            present(navController,animated: true, completion: nil)
            
            return false
        } else {
            return true
        }
        
       // return false // disable tapBar functionality
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        //check if the user is logged in
        if Auth.auth().currentUser == nil {
            //to get rid of "whose view is not in the window hierarchy!" warning
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        
        setupViewControllers()
        
       
    }
    
    func setupViewControllers() {
        
        //home
        let homeNavController = templateNavcontroller(unSelectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        //serach
        let searchNavController = templateNavcontroller(unSelectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"))
        //plus
        let plusNavController = templateNavcontroller(unSelectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        //like
        let likeNacController = templateNavcontroller(unSelectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
        //user Profile
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = .black
        
        viewControllers = [homeNavController,
                           searchNavController,
                           plusNavController,
                           likeNacController,
                           userProfileNavController]
       // viewControllers = [navController, UIViewController()]
        //modify tab bar insets into middle
        guard let items = tabBar.items else {return} //handle erros and avoid for unwrapping this way never crach the app
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0) //push dow the icons 4px down
        }
    }
    
    fileprivate func templateNavcontroller(unSelectedImage: UIImage, selectedImage:UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unSelectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}







