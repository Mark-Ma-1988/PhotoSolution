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
    let photoSolution = PhotoSolution()
    var alertController: UIAlertController!
    private let maxPhotos = 9
    //
    private let reuseIdentifier = "PostCellIdentifier"
    private var postArray = [Post]()
    private var hasMoreData = true
    let refreshControl = UIRefreshControl()
    
    @IBAction func postClick(_ sender: UIBarButtonItem) {
        var alertController: UIAlertController
        if UIDevice.current.userInterfaceIdiom == .phone{
            alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        }else{
            alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        }
        let takeAction = UIAlertAction(title: "Take a photo", style: .default, handler: { action in
            self.present(self.photoSolution.getCamera(), animated: true, completion: nil)
        })
        let findAction = UIAlertAction(title: "From my album", style: .default, handler: { action in
            let remainPhotos = self.maxPhotos
            self.present(self.photoSolution.getPhotoPicker(maxPhotos: remainPhotos), animated: true, completion: nil)
        })
        let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        })
        alertController.addAction(takeAction)
        alertController.addAction(findAction)
        alertController.addAction(cancleAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(getLatestPosts), name: NSNotification.Name(rawValue:"refreshData"), object: nil)
        configPhotoSolution()
        configPostTableView()
        getPostData(fromPostID: 0)
    }
    
    func configPostTableView(){
        let postCellNib = UINib(nibName: "PostCell", bundle: nil)
        postTableView.register(postCellNib, forCellReuseIdentifier: reuseIdentifier)
        postTableView.tableFooterView = UIView()
        postTableView.separatorColor = UIColor.lightGray
        if UIDevice.current.userInterfaceIdiom == .pad{
            postTableView.estimatedRowHeight = 250
        }else{
            postTableView.estimatedRowHeight = 200
        }
        postTableView.rowHeight = UITableView.automaticDimension
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Data")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            postTableView.refreshControl = refreshControl
        } else {
            postTableView.backgroundView = refreshControl
        }
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        getPostData(fromPostID: 0)
    }
    
    func getPostData(fromPostID: Int){
        indicatorView.isHidden = false
        WebService.shared.getPost(lastPostID: fromPostID, successHandler: {postArray,hasMoreData in
            self.indicatorView.isHidden = true
            self.hasMoreData = hasMoreData
            if self.refreshControl.isRefreshing{
                self.refreshControl.endRefreshing()
            }
            if fromPostID == 0{
                self.postArray = postArray
                self.postTableView.reloadData()
            }else{
                var indexPaths=[IndexPath]()
                for i in (self.postArray.count) ..< (self.postArray.count + postArray.count)
                {
                    let indexPath = IndexPath(row: i, section: 0)
                    indexPaths.append(indexPath)
                }
                self.postArray.append(contentsOf: postArray)
                self.postTableView.beginUpdates()
                self.postTableView.insertRows(at: indexPaths, with: UITableView.RowAnimation.none)
                self.postTableView.endUpdates()
            }
        }) { error in
            self.indicatorView.isHidden = true
            self.sendAlert(alertMessage: error)
        }
    }
    
    func sendAlert(alertMessage: String){
        let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "OK", style: .cancel, handler: { action in
            UIApplication.shared.openURL(NSURL(string:UIApplication.openSettingsURLString)! as URL)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        photoSolution.delegate = self
    }
    
    func configPhotoSolution(){
        photoSolution.customization.markerColor = UIColor.blue
        photoSolution.customization.navigationBarBackgroundColor = UIColor.darkGray
        photoSolution.customization.navigationBarTextColor = UIColor.white
        photoSolution.customization.titleForAlbum = "Album"
        photoSolution.customization.alertTextForPhotoAccess = "Your App Would Like to Access Your Photos"
        photoSolution.customization.settingButtonTextForPhotoAccess = "Setting"
        photoSolution.customization.cancelButtonTextForPhotoAccess = "Cancel"
        photoSolution.customization.alertTextForCameraAccess = "Your App Would Like to Access Your Photos"
        photoSolution.customization.settingButtonTextForCameraAccess = "Setting"
        photoSolution.customization.cancelButtonTextForCameraAccess = "Cancel"
        photoSolution.customization.returnImageSize = .compressed
        photoSolution.customization.statusBarColor = .white
        
    }
    
    @objc func getLatestPosts(notification : Notification){
        let str = notification.userInfo!["post"]
        print(String(describing: str!) + "this notifi")
        getPostData(fromPostID: 0)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostPage" {
            if let postViewController = segue.destination as? PostViewController {
                let images: [UIImage] = sender as! [UIImage]
                postViewController.currentImages = images
                postViewController.photoSolution = photoSolution
            }
        }
    }
 

}

extension BrowserViewController: PhotoSolutionDelegate{
    
    func returnImages(_ images: [UIImage]) {
       self.performSegue(withIdentifier: "toPostPage", sender: images)
    }
    
    func pickerCancel() {
        print("User close it!")
    }
    
}

extension BrowserViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PostCell
        let post = postArray[indexPath.row]
        cell.configViewWithData(post: post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (postArray.count - 1) && hasMoreData{
            let post = postArray[indexPath.row]
            getPostData(fromPostID: post.postID)
        }
    }

    
}

extension BrowserViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
