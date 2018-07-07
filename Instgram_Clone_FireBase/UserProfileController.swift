//
//  UserProfileController.swift
//  Instgram_Clone_FireBase
//
//  Created by Patrik Kemeny on 7/7/18.
//  Copyright © 2018 Patrik Kemeny. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
       // navigationItem.title = Auth.auth().currentUser?.uid
        fetchUser()
    }
    
    fileprivate func fetchUser() { //just acces inside this class
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            print(snapshot.value ?? "deafult printout")
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let username = dictionary["username"] as? String
            self.navigationItem.title = username
        }) { (error) in
            print("Failed to fetch user:", error)
        }
            
        
        
    }
}
