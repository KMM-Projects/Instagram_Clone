//
//  ViewController.swift
//  Instgram_Clone_FireBase
//
//  Created by Patrik Kemeny on 1/7/18.
//  Copyright © 2018 Patrik Kemeny. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    
    let plusPhotoButton : UIButton  = {
        let button =  UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true // enable to edit picture (orezat, zooming etc.) to cierne pozadie
        
        present(imagePickerController, animated: true, completion: nil)
    }
    //to knwo what image we picked up with image picker controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       //to pick the edited Image and work with edited image
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
           
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal) //set selected image as PlusButtonImage
        
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal) //set selected image as PlusButtonImage
        
        }
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2  //put the picedk pisture into circle
        plusPhotoButton.layer.masksToBounds = true
         dismiss(animated: true, completion: nil)
    }
    
    //emailtextField
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
       tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        //changeEditing
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.isEmpty != true && usernametextField.text?.isEmpty != true && passwordtextField.text?.isEmpty != true
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    
    //usernameTextField
    let usernametextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    //passwordtextField
    let passwordtextField: UITextField = {
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
        button.backgroundColor = UIColor.rgb(red: 149,green: 204,blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        //click on Button to create Action
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    @objc func handleSignUp(){
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let username = usernametextField.text, !username.isEmpty else { return }
        guard let password = passwordtextField.text, !password.isEmpty else { return }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error: Error?) in
            
            if let err = error {
                print("Failed to create user:", err)
                return
            }
            
            print("Successfully created user:", user?.uid ?? "")
            // upload profileImage to Cloude Storage
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }//30% compresion
            let filename = NSUUID().uuidString //bc we want each photo have an random name/ prevent from picture overwriting in storage
            Storage.storage().reference().child("profile_images").child(filename).putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    print("Failed to upload Image: ", error)
                    return
                }
                
                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else {return}
                print("Succesfully uploaded profile image!", profileImageUrl)
                            guard let uid = user?.uid else { return }
                let dictionaryValues = ["username" : username, "profileImageUrl": profileImageUrl]
                            let values = [uid : dictionaryValues]
                            Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                                if let error = err {
                                    print("Failed to save user information into database:", err)
                                    return
                                }
                                print("Succesfully saved user info into database")
                            })
            })
            
            

      })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(plusPhotoButton) // button not visible
        
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
        setupInputField()
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     }
    
    fileprivate func setupInputField(){

        let redView = UIView()
        redView.backgroundColor = .red
     
        
     let stackView = UIStackView(arrangedSubviews: [emailTextField,usernametextField,passwordtextField,signUpButton])
       
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
      
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
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









