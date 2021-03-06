




//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Brian Voong on 3/15/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && usernameTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        button.isEnabled = false
        
        return button
    }()
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text, email.characters.count > 0 else { return }
        guard let username = usernameTextField.text, username.characters.count > 0 else { return }
        guard let password = passwordTextField.text, password.characters.count > 0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: FirebaseAuth.User?, error: Error?) in
            
            if let err = error {
                print("Failed to create user:", err)
                return
            }
            
            print("Successfully created user:", user?.uid ?? "")
            
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
            
            let filename = NSUUID().uuidString
            Storage.storage().reference().child("profile_images").child(filename).putData(uploadData, metadata: nil, completion: { (metadata, err) in
                
                if let err = err {
                    print("Failed to upload profile image:", err)
                    return
                }
                
                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
                
                print("Successfully uploaded profile image:", profileImageUrl)
                
                guard let uid = user?.uid else { return }
                
                let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl]
                let values = [uid: dictionaryValues]
                
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                    
                    if let err = err {
                        print("Failed to save user info into db:", err)
                        return
                    }
                    
                    print("Successfully saved user info to db")
                    //dismiss signUp controller and
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
                    mainTabBarController.setupViewControllers()
                    self.dismiss(animated: true, completion: nil)
                    
                })
                
                
            })
            
        })
    }
    
    let haveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray,NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: "Sign in", attributes: [NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        // button.setTitle("Don't have an account? Sign up.",for: .normal)
        //transition to sign in view
        button.addTarget(self, action: #selector(handleHaveAccount), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleHaveAccount() {
     //pop back to the login controller into begining
       _ = navigationController?.popViewController(animated: true) //get rid of warnin, bc this method is returning a controller but we are not handling it
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(haveAccountButton)
        haveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
    }
    
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
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












////
////  ViewController.swift
////  Instgram_Clone_FireBase
////
////  Created by Patrik Kemeny on 1/7/18.
////  Copyright © 2018 Patrik Kemeny. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//
//
//    let plusPhotoButton : UIButton  = {
//        let button =  UIButton(type: .system)
//        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
//        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
//        return button
//    }()
//
//
//    @objc func handlePlusPhoto() {
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//        imagePickerController.allowsEditing = true // enable to edit picture (orezat, zooming etc.) to cierne pozadie
//
//        present(imagePickerController, animated: true, completion: nil)
//    }
//    //to knwo what image we picked up with image picker controller
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//       //to pick the edited Image and work with edited image
//        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
//
//            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal) //set selected image as PlusButtonImage
//
//        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
//
//            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal) //set selected image as PlusButtonImage
//
//        }
//        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2  //put the picedk pisture into circle
//        plusPhotoButton.layer.masksToBounds = true
//         dismiss(animated: true, completion: nil)
//    }
//
//    //emailtextField
//    let emailTextField: UITextField = {
//        let tf = UITextField()
//        tf.placeholder = "Email"
//       tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
//        tf.borderStyle = .roundedRect
//        tf.font = UIFont.systemFont(ofSize: 14)
//        //changeEditing
//        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
//
//        return tf
//    }()
//
//    @objc func handleTextInputChange() {
//        let isFormValid = emailTextField.text?.isEmpty != true && usernametextField.text?.isEmpty != true && passwordtextField.text?.isEmpty != true
//
//        if isFormValid {
//            signUpButton.isEnabled = true
//            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
//        } else {
//            signUpButton.isEnabled = false
//            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
//        }
//    }
//
//
//    //usernameTextField
//    let usernametextField: UITextField = {
//        let tf = UITextField()
//        tf.placeholder = "Username"
//        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
//        tf.borderStyle = .roundedRect
//        tf.font = UIFont.systemFont(ofSize: 14)
//        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
//
//        return tf
//    }()
//    //passwordtextField
//    let passwordtextField: UITextField = {
//        let tf = UITextField()
//        tf.placeholder = "Password"
//        tf.isSecureTextEntry = true
//        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
//        tf.borderStyle = .roundedRect
//        tf.font = UIFont.systemFont(ofSize: 14)
//        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
//
//        return tf
//    }()
//
//    let signUpButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Sign Up", for: .normal)
//        button.backgroundColor = UIColor.rgb(red: 149,green: 204,blue: 244)
//        button.layer.cornerRadius = 5
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
//        button.setTitleColor(.white, for: .normal)
//
//        //click on Button to create Action
//        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
//        button.isEnabled = false
//        return button
//    }()
//
//    @objc func handleSignUp(){
//        guard let email = emailTextField.text, !email.isEmpty else { return }
//        guard let username = usernametextField.text, !username.isEmpty else { return }
//        guard let password = passwordtextField.text, !password.isEmpty else { return }
//
//        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error: Error?) in
//
//            if let err = error {
//                print("Failed to create user:", err)
//                return
//            }
//
//            print("Successfully created user:", user?.uid ?? "")
//            // upload profileImage to Cloude Storage
//            guard let image = self.plusPhotoButton.imageView?.image else { return }
//            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }//30% compresion
//            let filename = NSUUID().uuidString //bc we want each photo have an random name/ prevent from picture overwriting in storage
//            Storage.storage().reference().child("profile_images").child(filename).putData(uploadData, metadata: nil, completion: { (metadata, error) in
//                if let error = error {
//                    print("Failed to upload Image: ", error)
//                    return
//                }
//
//                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else {return}
//                print("Succesfully uploaded profile image!", profileImageUrl)
//                            guard let uid = user?.uid else { return }
//                let dictionaryValues = ["username" : username, "profileImageUrl": profileImageUrl]
//                            let values = [uid : dictionaryValues]
//                            Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
//                                if let error = err {
//                                    print("Failed to save user information into database:", err)
//                                    return
//                                }
//                                print("Succesfully saved user info into database")
//                            })
//            })
//
//
//
//      })
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(plusPhotoButton) // button not visible
//
//        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
//        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//
//        setupInputField()
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//     }
//
//    fileprivate func setupInputField(){
//
//        let redView = UIView()
//        redView.backgroundColor = .red
//
//
//     let stackView = UIStackView(arrangedSubviews: [emailTextField,usernametextField,passwordtextField,signUpButton])
//
//        stackView.distribution = .fillEqually
//        stackView.axis = .vertical
//        stackView.spacing = 10
//
//
//        view.addSubview(stackView)
//        NSLayoutConstraint.activate([
//                        ])
//
//        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
//
//    }
//
//
//}
//
//
//extension UIView {
//    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
//
//        translatesAutoresizingMaskIntoConstraints = false
//
//
//        if let top = top {
//            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
//        }
//        if let left = left {
//            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
//        }
//        if let bottom = bottom {
//            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
//        }
//        if let right = right {
//            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
//        }
//        if width != 0 {
//            widthAnchor.constraint(equalToConstant: width).isActive = true
//        }
//        if height != 0 {
//            heightAnchor.constraint(equalToConstant: height).isActive = true
//        }
//    }
//}
//
//
//
//
//
//
//
//
//
