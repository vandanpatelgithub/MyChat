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
    
    static func fetchUser(withUID uid: String, completion: @escaping (User?, Error?) -> ()) {
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                completion(nil, error)
            }
            
            if let data = snapshot?.data() {
                let user = User(dictionary: data)
                completion(user, nil)
            }
        }
    }
}
