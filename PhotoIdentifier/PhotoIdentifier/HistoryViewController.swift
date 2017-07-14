//
//  HistoryViewController.swift
//  PhotoIdentifier
//
//  Created by JOSE PILAPIL on 2017-07-13.
//  Copyright © 2017 JOSE PILAPIL. All rights reserved.
//

import UIKit
import Firebase
class HistoryViewController: ViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        super.viewDidLoad()
      
        Dataservice.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            self.posts.removeAll()
            if let snapshots = snapshot.children.allObjects as?
                [DataSnapshot] {
                for snap in snapshots{
                    print("Snap:\(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                        print(self.posts.count)
                    }
                }
                self.posts = self.posts.reversed()
            }
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    //MARK: TABLEVIEW FUNCTIONS:
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        print("\(post.response)")
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "identifier") as? TheCustomCell {
            if let img = HistoryViewController.imageCache.object(forKey: post.imageUrl as NSString){
                cell.configureCell(post: post, img: img)
                return cell
            } else{
                cell.configureCell(post: post)
            }
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "identifier") as! TheCustomCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        
        let ac = UIAlertController(title: "Hello", message: "TODO: DetailVC", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        ac.addAction(defaultAction)
        
        present(ac, animated: true, completion: nil)
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                
                dismiss(animated: true, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if(touch.view?.isDescendant(of: self.tableView) == true){
            return false
        } else{
            return true
        }
    }
    
}




