//
//  Post.swift
//  PhotoIdentifier
//
//  Created by JOSE PILAPIL on 2017-07-13.
//  Copyright © 2017 JOSE PILAPIL. All rights reserved.
//

import Foundation
import Firebase


class Post {
    
    private var _reponse: String!
    private var _imageUrl: String!
    private var _postId: String!
    private var _correct: Bool!
    private var _PostRef: DatabaseReference!
    
    var response: String {
        return _reponse
    }
    
    var imageUrl: String{
        return _imageUrl
    }
    
    var postID: String{
        return _postId
    }
    
    var correct: Bool {
        return _correct
    }
    
    init(reponse: String, imageUrl: String){
        self._reponse = reponse
        self._imageUrl = imageUrl
    }
    
    init(postKey: String, postData: Dictionary<String,AnyObject>) {
        self._postId = postKey
        
        if let response = postData["response"] as? String {
            self._reponse = response
        }
        
        if let imageUrl = postData["imgUrl"] as? String{
            self._imageUrl = imageUrl
        }
        
        if let correct = postData["correct"] as? Bool {
            self._correct = correct
        }
        _PostRef = Dataservice.ds.REF_POSTS.child(_postId)
        
    }
}

