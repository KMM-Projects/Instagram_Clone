//
//  UserProfileHeader.swift
//  Instgram_Clone_FireBase
//
//  Created by Patrik Kemeny on 7/7/18.
//  Copyright © 2018 Patrik Kemeny. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
        
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
    
    }
    var user: User? {
        didSet {
            setupProfileImage()
           
        }
    }
    fileprivate func setupProfileImage() {
        guard let profileImageUrl = user?.profileImageUrl else {return}
        let url = URL(fileURLWithPath: profileImageUrl) // link to profile picture in firebase urlstring
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            //check for error and than construct the image using data
            if let error = error {
                print("Failed to fetcg profile pecture with error: ",error)
                return
            }
            // print(data)
            //perhaps check for 200 response (HHTP OK)
            guard let data = data else { return }
            let image = UIImage(data: data)
            // get back to main UI thread
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
            }.resume() // never forget in datatask
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
