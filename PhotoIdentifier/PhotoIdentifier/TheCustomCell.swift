//
//  TheCustomCell.swift
//  PhotoIdentifier
//
//  Created by JOSE PILAPIL on 2017-07-13.
//  Copyright © 2017 JOSE PILAPIL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class TheCustomCell: UITableViewCell {
    @IBOutlet weak var responseLabel: UILabel!
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var truthView: RoundView!
    
    
    var post: Post!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(post: Post, img: UIImage? = nil){
        self.post = post
        
        self.responseLabel.text = post.response
        
        self.truthView.backgroundColor = post.correct ? UIColor.green : UIColor.red
        
        if img != nil {
            self.myImageView.image = img
        } else {
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            ref.getData(maxSize: 3 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Unable to download images from Firebase Storage \(error!)")
                } else {
                    print("image downloaded from firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData){
                            self.myImageView.image = img
                            HistoryViewController.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
    }
}
