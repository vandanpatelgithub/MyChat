//
//  AuthService.swift
//  MyChat
//
//  Created by Vandan Patel on 10/11/20.
//

import Firebase

struct RegistrationCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let imageData: Data
}

struct User {
    let email: String
    let fullname: String
    let imageURL: String
    let uid: String
    let username: String
    
    init(credentials: RegistrationCredentials, imageURL: String, uid: String) {
        email = credentials.email
        fullname = credentials.fullname
        username = credentials.username
        self.imageURL = imageURL
        self.uid = uid
    }
    
    var toDict: [String: Any] {
        return [
            "email": email,
            "fullName": fullname,
            "profileImageURL": imageURL,
            "uid": uid,
            "username": username
        ]
    }
}

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func createUser(withCredentials credentials: RegistrationCredentials, completion: @escaping ((Error?) -> Void)) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        ref.putData(credentials.imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(error)
                return
            }
            
            ref.downloadURL { (url, error) in
                if let error = error {
                    completion(error)
                    return
                }
                
                guard let profileImageURL = url?.absoluteString else {
                    completion(error)
                    return
                }
                
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                    if let error = error {
                        completion(error)
                        return
                    }
                    guard let uid = result?.user.uid else {
                        completion(error)
                        return
                    }
                    
                    let user = User(credentials: credentials, imageURL: profileImageURL, uid: uid)
                    
                    Firestore.firestore().collection("users").document(uid).setData(user.toDict, completion: completion)
                }
            }
        }
    }
}
