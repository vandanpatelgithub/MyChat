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
                print("DEBUG: failed to upload the image with error \(error.localizedDescription)")
                completion(error)
                return
            }
            
            ref.downloadURL { (url, error) in
                if let error = error {
                    print("DEBUG: failed to download the url with error \(error.localizedDescription)")
                    completion(error)
                    return
                }
                
                guard let profileImageURL = url?.absoluteString else {
                    completion(error)
                    return
                }
                
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                    if let error = error {
                        print("DEBUG: failed to create the user with error \(error.localizedDescription)")
                        completion(error)
                        return
                    }
                    guard let uid = result?.user.uid else {
                        completion(error)
                        return
                    }
                    
                    let data = ["email": credentials.email,
                                "fullName": credentials.fullname,
                                "profileImageURL": profileImageURL,
                                "uid": uid,
                                "username": credentials.username] as [String: Any]
                    
                    Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
                }
            }
        }
    }
}
