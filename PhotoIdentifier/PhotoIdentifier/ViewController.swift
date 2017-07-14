//
//  ViewController.swift
//  PhotoIdentifier
//
//  Created by JOSE PILAPIL on 2017-07-09.
//  Copyright © 2017 JOSE PILAPIL. All rights reserved.
//

import UIKit
import MobileCoreServices
import CloudSight
import Firebase
import FirebaseAuth
import FirebaseDatabase


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var responseField: UITextView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    var ref: DatabaseReference!
    var newMedia: Bool?
    var cloudsightQuery: CloudSightQuery!
    var downloadURL: String?
    
    var success: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        CloudSightConnection.sharedInstance().consumerKey = "_5uLhqSMAVc6ZikHeIG6zw";
        CloudSightConnection.sharedInstance().consumerSecret = "Xp7LoRL29MH1jQDrxJpJIw";
        
        print(Auth.auth().currentUser ?? "banana")
        print(Auth.auth().currentUser?.uid ?? "banana")
        ref = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        self.responseField.text = ""
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true,
                         completion: nil)
            newMedia = true
            print(Auth.auth().currentUser?.uid ?? "banana")
        }
    }
    

    @IBAction func selectPhoto(_ sender: Any) {
            self.responseField.text = ""
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.savedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true,
                         completion: nil)
            newMedia = false
            print(Auth.auth().currentUser ?? "banana")
            print(Auth.auth().currentUser?.uid ?? "banana")
            
        }
    }
    
    
    //MARK: imagePicker Delegate Functions
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            imageView.image = image
            
            // Create JPG image data from UIImage
            let imageData = UIImageJPEGRepresentation(image, 0.8)
            let imgUID = NSUUID().uuidString
            
            _ = Dataservice.ds.REF_POST_IMAGES.child(imgUID).putData(imageData!, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                self.downloadURL = metadata.downloadURL()?.absoluteString
            }
            
            cloudsightQuery = CloudSightQuery(image: imageData,
                                              atLocation: CGPoint.zero,
                                              withDelegate: self,
                                              atPlacemark: nil,
                                              withDeviceId: "device-id")
            cloudsightQuery.start()
            self.activityIndicatorView.isHidden = false;
            self.activityIndicatorView.startAnimating()
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                                               #selector(ViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
            } else if mediaType.isEqual(to: kUTTypeMovie as String) {
                // Code to support video here
            }
            
        }
    }
    
   
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                                          message: "Failed to save image",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true,
                         completion: nil)
        }
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: cloudSightDelegate Methods
    
    func cloudSightQueryDidFinishUploading(_ query: CloudSightQuery!) {
        print("cloudSightQueryDidFinishUploading")
    }
    
    func cloudSightQueryDidFinishIdentifying(_ query: CloudSightQuery!) {
        print("cloudSightQueryDidFinishIdentifying")
        
        // CloudSight runs in a background thread, and since we're only
        // allowed to update UI in the main thread, let's make sure it does.
        DispatchQueue.main.async {
            self.responseField.text = query.name()
            self.activityIndicatorView.isHidden = true;
            self.activityIndicatorView.stopAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                
                let ac = UIAlertController(title: "Hello!", message: "Did the App Get the Image Correct?", preferredStyle: .alert)
                
                let yesAction = UIAlertAction(title: "YES", style: .default, handler: { (UIAlertAction) in
                    self.success = true
                })
                let noAction = UIAlertAction(title: "NO", style: .cancel, handler: { (UIAlertAction) in
                    self.success = false
                })
                
                ac.addAction(yesAction)
                ac.addAction(noAction)
                
                self.present(ac, animated: true, completion: nil)
            })
        }
    }
    
    func cloudSightQueryDidFail(_ query: CloudSightQuery!, withError error: Error!) {
        print("CloudSight Failure: \(error)")
    }


    
    
    
    @IBAction func saveToDatabase(_ sender: Any) {
        
        if(self.responseField.text == "" || self.imageView.image == nil || self.success == nil){
            
            let alertController = UIAlertController(title: "Error", message: "Please wait for app to finish processing before posting", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
            
        } else {
            let key = Dataservice.ds.REF_POSTS.childByAutoId().key
            let post: Dictionary <String, AnyObject> =
                ["response": self.responseField.text as AnyObject,
                 "imgUrl": self.downloadURL as AnyObject,
                 "postedBy": Auth.auth().currentUser?.uid as AnyObject,
                 "correct": self.success as AnyObject
            ]
            
            let fireBasePost = Dataservice.ds.REF_POSTS.childByAutoId()
            
            let childUpdates = ["/Posts/\(key)": post,
                                "/Users/\(Dataservice.ds.REF_USER_CURRENT)/posts/\(key)":post]
            
            Dataservice.ds.REF_BASE.updateChildValues(childUpdates)
            
            dismiss(animated: true, completion: nil)
            
            
        }
        
        
        
    }

    
    
    @IBAction func clickedCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


