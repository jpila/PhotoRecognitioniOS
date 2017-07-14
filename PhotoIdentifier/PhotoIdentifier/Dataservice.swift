//
//  Dataservice.swift
//  PhotoIdentifier
//
//  Created by JOSE PILAPIL on 2017-07-13.
//  Copyright © 2017 JOSE PILAPIL. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class Dataservice {
    
    static let ds = Dataservice()
    
    //DB References
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("Posts")
    private var _REF_USERS = DB_BASE.child("Users")
    
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    //Storage Reference
    
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    
    var REF_POST_IMAGES: StorageReference {
        
        return _REF_POST_IMAGES
    }
    
    var REF_USER_CURRENT: String{
        
        let uid = Auth.auth().currentUser?.uid
      
        return uid!
    }
    

    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String,String>){
        REF_USERS.child(uid).setValue(userData)
    }
    
    
}
