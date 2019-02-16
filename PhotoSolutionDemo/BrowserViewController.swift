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
