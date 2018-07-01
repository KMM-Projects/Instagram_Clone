//
//  ViewController.swift
//  Instgram_Clone_FireBase
//
//  Created by Patrik Kemeny on 1/7/18.
//  Copyright © 2018 Patrik Kemeny. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    let plusPhotoButton : UIButton  = {
        let button =  UIButton(type: .system)
       // button.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
      //  button.translatesAutoresizingMaskIntoConstraints = false //to be able to use anchoring and make the object visible
        
        return button
    }()
    //emailtextField
    let emailTextFiel: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
     //   tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    //usernameTextField
    let usernametextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
      //  tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    //passwordtextField
    let passwordtextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
       // tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        //button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1) used extensions
        button.backgroundColor = UIColor.rgb(red: 149,green: 204,blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(plusPhotoButton) // button not visible
        
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        
//        plusPhotoButton.frame = CGRect(x: 0 , y: 0, width: 140, height: 140) // nee to create a freame to make button visible
//        plusPhotoButton.center = view.center
//        plusPhotoButton.heightAnchor.constraint(equalToConstant: 140).isActive = true
//        plusPhotoButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        plusPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        
        setupInputField()
        
//        //email TextField
//        view.addSubview(emailTextFiel)
//        //activation with no .isActive = true
//        NSLayoutConstraint.activate([
//            emailTextFiel.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 20),
//            emailTextFiel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
//            emailTextFiel.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -40),
//            emailTextFiel.heightAnchor.constraint(equalToConstant: 50)
//            ])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupInputField(){
//        let greenView = UIView()
//        greenView.backgroundColor = .green
//
        let redView = UIView()
        redView.backgroundColor = .red
     
        
     let stackView = UIStackView(arrangedSubviews: [emailTextFiel,usernametextField,passwordtextField,signUpButton])
        //stackView.translatesAutoresizingMaskIntoConstraints = false
       
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
      
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
                        //stackView.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 20),
                       // stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
                      //  stackView.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -40),
                       // stackView.heightAnchor.constraint(equalToConstant: 200)
                        ])
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
        
    }


}


extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
       
        translatesAutoresizingMaskIntoConstraints = false
        
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}









