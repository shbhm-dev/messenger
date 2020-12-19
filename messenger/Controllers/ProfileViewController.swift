//
//  ProfileViewController.swift
//  messenger
//
//  Created by STARKS on 12/14/20.
//  Copyright © 2020 STARKS. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
class ProfileViewController: UIViewController {
    @IBOutlet var tableView : UITableView!
    let data = ["Log Out"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    

  
}
extension ProfileViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textColor = .red
        cell.textLabel?.textAlignment = .center
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let actionSheet = UIAlertController(title: "Log out", message: "Are you sure you want to logout", preferredStyle: .actionSheet)
                  
                  actionSheet.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { _ in
                     FBSDKLoginKit.LoginManager().logOut()
                    do
                    {
                        
                        try FirebaseAuth.Auth.auth().signOut()
                        let vc = LoginViewController()
                        let nav = UINavigationController(rootViewController: vc)
                        nav.modalPresentationStyle = .fullScreen
                        self.present(nav,animated: true)
                        
                    }
                    catch {
                        
                    }
                  }))
                  
                  actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
       
        present(actionSheet,animated: true)
        
    }
    
    
    
    
}
