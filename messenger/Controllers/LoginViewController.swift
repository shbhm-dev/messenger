//
//  LoginViewController.swift
//  messenger
//
//  Created by STARKS on 12/14/20.
//  Copyright © 2020 STARKS. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
class LoginViewController: UIViewController {
    
    let loginButton : FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email,public_profile"]
        return button
    }()
    let imageView = UIImageView()
    let emailFeild = UITextField()
    let passwordFeild = UITextField()
    let submitBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        loginButton.delegate = self
        loginButton.center = view.center
        view.addSubview(loginButton)
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        setupViews()
        view.backgroundColor = .white
    }
    
    
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc.title = "Register"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func submitTapped()
    {
        guard let email = emailFeild.text , let password = passwordFeild.text,!email.isEmpty , !password.isEmpty,password.count >= 6 else
        {
            alertUserLoginError()
            return;
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { (authRes, err) in
            
            guard let res = authRes , err == nil else
            {
                print("error ")
                return
            }
            
            print("loggedin")
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        
        
    }
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops",
                                      message: "Please enter all information to log in.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    func setupViews()
    {
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo")
        
        
        
        emailFeild.placeholder = "Enter the Email ID"
        emailFeild.borderStyle = .roundedRect
        
        
        passwordFeild.placeholder = "Enter the Password"
        passwordFeild.borderStyle = .roundedRect
        
        
        
        submitBtn.backgroundColor = .systemBlue
        submitBtn.layer.cornerRadius = 10
        submitBtn.setTitle("Submit", for: .normal)
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        submitBtn.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        view.addSubview(imageView)
        view.addSubview(emailFeild)
        view.addSubview(passwordFeild)
        view.addSubview(submitBtn)
        
        passwordFeild.translatesAutoresizingMaskIntoConstraints = false
        emailFeild.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.bounds.width/3).isActive = true
        
        emailFeild.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailFeild.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
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
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
         loginButton.topAnchor.constraint(equalTo: submitBtn.bottomAnchor, constant: 10).isActive = true
        
        
        
        
        
    }
    
    
    
}
extension LoginViewController : LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // no operations
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        guard let token = result?.token?.tokenString else
        {
            print("failed to login user!")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
        parameters: ["fields":
           "email, name"],
        tokenString: token,
        version: nil,
        httpMethod: .get)
        
        facebookRequest.start { (connection, result, err) in
           guard let results = result as? [String : Any], err == nil else {
                return
            }
            
            print("\(results)")
            
            guard let Firstname = results["name"] as? String ,
                let email = results["email"] as? String else
            {
                print("Could not fetch credentials from faceboo")
                return
            }
            DatabaseManager.shared.userExists(with: email) { (exists) in
                if !exists {
                    DatabaseManager.shared.insertUser(with: ChatUser(firstname: Firstname, emailId: email))
                }
            }
            
            
            let credentials = FacebookAuthProvider.credential(withAccessToken: token)
                  
                  FirebaseAuth.Auth.auth().signIn(with: credentials) { (res, err) in
                      guard let authRes = res , err == nil else {
                          return
                      }
                      print("loggedin using FB")
                      self.navigationController?.dismiss(animated: true, completion: nil)
                  }
            
            
        }
        
        
        
      
        
    }
    
    
}
