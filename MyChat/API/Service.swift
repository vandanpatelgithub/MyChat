//
//  Service.swift
//  MyChat
//
//  Created by Vandan Patel on 10/14/20.
//

import Foundation
import Firebase

struct Service {
    static func fetchUsers(completion: @escaping ([User]) -> ()) {
        var users = [User]()
        Firestore.firestore().collection("users").getDocuments { (snapshot, error) in
            if error != nil { completion([]) }
            
            snapshot?.documents.forEach({ document in
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                users.append(user)
            })
            completion(users)
        }
    }
}
