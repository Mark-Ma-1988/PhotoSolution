//
//  BrowserViewController.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 7/2/19.
//  Copyright © 2019 mark. All rights reserved.
//

import UIKit

class BrowserViewController: UIViewController {

    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var postTableView: UITableView!
    
    @IBAction func postClick(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "toPostPage", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(getLatestPosts), name: NSNotification.Name(rawValue:"refreshData"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func getLatestPosts(notification : Notification){
        let str = notification.userInfo!["post"]
        print(String(describing: str!) + "this notifi")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostPage" {
            if let postViewController = segue.destination as? PostViewController {
                
            }
        }
    }
 

}
