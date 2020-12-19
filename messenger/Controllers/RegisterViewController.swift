//
//  RegisterViewController.swift
//  messenger
//
//  Created by STARKS on 12/14/20.
//  Copyright © 2020 STARKS. All rights reserved.
//

import UIKit
import FirebaseAuth
class RegisterViewController: UIViewController {
    
    let firstnameFeild = UITextField()
    var imageView: UIButton!
    let emailFeild = UITextField()
    let passwordFeild = UITextField()
    let submitBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        
        
        setupViews()
        view.backgroundColor = .white
    }
    
    
    
    @objc func submitTapped()
    {
        guard let email = emailFeild.text , let password = passwordFeild.text,!email.isEmpty , !password.isEmpty,password.count >= 6 , let firstName = firstnameFeild.text ,!firstName.isEmpty else
        {
            alertUserLoginError()
            return;
        }
        DatabaseManager.shared.userExists(with: email) { (exists) in
            guard !exists else {
                // User Already Exists
                self.alertUserLoginError(message: "User Already Exists")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { (authRes, err) in
                guard let res = authRes,err == nil
                else{
                    print("Not created")
                    return;
                }
             }
            
            DatabaseManager.shared.insertUser(with: ChatUser(firstname: firstName, emailId: email))
            
            self.navigationController?.dismiss(animated: true, completion: nil)
            
            
        }
        
        

        
    }
    func alertUserLoginError(message : String = "Please enter all the info") {
        let alert = UIAlertController(title: "Woops",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    @objc func didTapChangeProfilePic() {
        presentActionSheet()
    }
    
    func setupViews()
    {
        
        imageView = UIButton()
        //        imageView.image = UIImage(systemName: "person.circle")
        imageView.setImage(UIImage(systemName:"person"), for: .normal)
        imageView.tintColor = .gray
        //        imageView.imageView?.contentMode = .scaleAspectFill
        imageView.contentHorizontalAlignment = .fill
        imageView.contentVerticalAlignment = .fill
       
        
        imageView.addTarget(self, action: #selector(didTapChangeProfilePic), for: .touchUpInside)
        
        firstnameFeild.placeholder = "Enter the First Name"
        firstnameFeild.borderStyle = .roundedRect
        firstnameFeild.translatesAutoresizingMaskIntoConstraints = false
        
        emailFeild.placeholder = "Enter the Email ID"
        emailFeild.borderStyle = .roundedRect
        
        
        passwordFeild.placeholder = "Enter the Password"
        passwordFeild.borderStyle = .roundedRect
        
        
        
        submitBtn.backgroundColor = .systemGreen
        submitBtn.layer.cornerRadius = 10
        submitBtn.setTitle("Submit", for: .normal)
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        submitBtn.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        view.addSubview(imageView)
        view.addSubview(emailFeild)
        view.addSubview(passwordFeild)
        view.addSubview(submitBtn)
        view.addSubview(firstnameFeild)
        
        
        passwordFeild.translatesAutoresizingMaskIntoConstraints = false
        emailFeild.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
        
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.bounds.width/2).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1).isActive = true
        
        
        
        
        firstnameFeild.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        firstnameFeild.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        firstnameFeild.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50).isActive = true
        firstnameFeild.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50).isActive = true
        
        
        emailFeild.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailFeild.topAnchor.constraint(equalTo: firstnameFeild.bottomAnchor, constant: 10).isActive = true
        emailFeild.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50).isActive = true
        emailFeild.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50).isActive = true
        
        
        
        passwordFeild.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordFeild.topAnchor.constraint(equalTo: emailFeild.bottomAnchor, constant: 10).isActive = true
        passwordFeild.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50).isActive = true
        passwordFeild.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50).isActive = true
        
        submitBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        submitBtn.topAnchor.constraint(equalTo: passwordFeild.bottomAnchor, constant: 10).isActive = true
        submitBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50).isActive = true
        submitBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50).isActive = true
        
        
        
        
        
        
    }
    
    
    
}
extension RegisterViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func presentActionSheet()
    {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Choose how you want to add the profile picture", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {
            _ in
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {
            _ in self.presentPhotoLib()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera()
    {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .camera
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    func presentPhotoLib()
    {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let selectedimg = info[UIImagePickerController.InfoKey.editedImage]
        self.imageView.setImage(selectedimg as! UIImage, for: .normal)
        
    }
    
    
}
