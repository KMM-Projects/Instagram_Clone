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
    var user: User? {
        didSet {
            setupProfileImage()
            
            usernameLabel.text = user?.username
            
        }
    }
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.1)
        return button
    }()
    let bookMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.1)
        return button
    }()
    
    let usernameLabel: UILabel = {
       let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postlabel:UILabel = {
       let label = UILabel()
     
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray,NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let folowwersLabel:UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray,NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let followingLabel:UILabel = {
        let label = UILabel()
        //this is how to create and 2 lines different font and color text in one label.line
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray,NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let editProfileButton:UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        
        //for grid list and ribbon button
        setupBottomToolbar()
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        setupUserStatsView()
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: postlabel.bottomAnchor, left: postlabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)
    }
    
    
    fileprivate func setupUserStatsView(){
        let stackView = UIStackView(arrangedSubviews: [postlabel,folowwersLabel,followingLabel])
       stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
        
    }
    
    fileprivate func setupBottomToolbar(){
        //setup bottom bar top and bottom lines
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        
        
        let stackView = UIStackView(arrangedSubviews: [gridButton,listButton,bookMarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
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
