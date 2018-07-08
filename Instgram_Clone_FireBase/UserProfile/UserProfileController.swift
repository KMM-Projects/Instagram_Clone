//
//  UserProfileController.swift
//  Instgram_Clone_FireBase
//
//  Created by Patrik Kemeny on 7/7/18.
//  Copyright © 2018 Patrik Kemeny. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
       // navigationItem.title = Auth.auth().currentUser?.uid
        fetchUser()
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        header.user = self.user
        // not correct
        //header.addSubview(UIImage())
        //header.backgroundColor = .green
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
        
    }
    var user: User?
    fileprivate func fetchUser() { //just acces inside this class
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            print(snapshot.value ?? "deafult printout")
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            //more profesional solution
            self.user = User(dictionary: dictionary)
            //less profesional solution
//            let profileImage = dictionary["profileImageUrl"] as? String
//            let username = dictionary["username"] as? String
            self.navigationItem.title = self.user?.username
            self.collectionView?.reloadData()
        }) { (error) in
            print("Failed to fetch user:", error)
        }
            
        
        
    }
}

struct User {
    let username: String
    let profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
    
}




