//
//  DatabaseManager.swift
//  messenger
//
//  Created by STARKS on 12/17/20.
//  Copyright © 2020 STARKS. All rights reserved.
//

import Foundation
import FirebaseDatabase
struct ChatUser{
    let firstname  : String
    let emailId : String
    var safeEmail : String {
       var safeEmail = emailId.replacingOccurrences(of: ".", with: "-")
               safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
final class DatabaseManager {
    
    static let shared  = DatabaseManager()
    
    private let database = Database.database().reference()
//   public func test()
//    {
//        database.child("foo").setValue(["something" : true])
//    }
//
    public func userExists(with email : String,completion : @escaping((Bool)-> Void))
    {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
         safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let foundEmail  = snapshot.value as? String else
            {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    
    public func insertUser(with user : ChatUser)
    {
        
        database.child(user.safeEmail).setValue(["first_name" : user.firstname
        ])
        
        
    }
    
    
    
    
}
