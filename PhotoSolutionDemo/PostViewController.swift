//
//  ViewController.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 8/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    @IBOutlet weak var editTextView: UITextView!
    @IBOutlet weak var pickedPhotoCollectionView: UICollectionView!
    private var cellSize: CGFloat!
    private let pickerCellReuseIdentifier = "PickerCell"
    private let space = CGFloat(8)
    var currentImages: [UIImage] = [UIImage]()
    private let maxPhotos = 9
    private let defaultWords = "Description about your photos..."
    private var hasDescription: Bool!
    @IBOutlet weak var progressView: UIProgressView!
    var photoSolution: PhotoSolution!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellSize = (pickedPhotoCollectionView.frame.width - 4 * space) / 3
        let dataCellNib = UINib(nibName: pickerCellReuseIdentifier, bundle: nil)
        pickedPhotoCollectionView.register(dataCellNib, forCellWithReuseIdentifier: pickerCellReuseIdentifier)
        pickedPhotoCollectionView.isScrollEnabled = true
        pickedPhotoCollectionView.bounces = false
        pickedPhotoCollectionView.reloadData()
        editTextView.delegate = self
        initTextView()
        
        photoSolution.delegate = self
        
        
//        let resignKeyboardGesture=UITapGestureRecognizer(target: self, action: #selector(resignKeyboard(_:)))
//        resignKeyboardGesture.numberOfTapsRequired = 1
//        self.view.isUserInteractionEnabled = true
//        self.view.addGestureRecognizer(resignKeyboardGesture)
//        editTextView.isUserInteractionEnabled = true
//        editTextView.addGestureRecognizer(resignKeyboardGesture)
//        pickedPhotoCollectionView.isUserInteractionEnabled = true
//        pickedPhotoCollectionView.addGestureRecognizer(resignKeyboardGesture)
    }
    
//    @objc private func resignKeyboard(_ gesture: UITapGestureRecognizer) {
//        editTextView.resignFirstResponder()
//    }
    
    func initTextView(){
        editTextView.text = defaultWords
        editTextView.textColor = UIColor.lightGray
        hasDescription = false
//        let range = NSRange(location: 0, length: 0)
//        editTextView.selectedRange = range
    }
    
    func startEditTextView(){
        editTextView.text = ""
        editTextView.textColor = UIColor.black
        hasDescription = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func calulateImageFileSize(_ image: UIImage?) {
        var data: Data? = image!.pngData()
        var dataLength = Double((data?.count ?? 0)) * 1.0
        let typeArray = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
        var index: Int = 0
        while dataLength > 1024 {
            dataLength /= 1024.0
            index += 1
        }
        print("image = \(dataLength) \(typeArray[index]) ")
    }
    
    func getPhotos() {
        
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
            let remainPhotos = self.maxPhotos - self.currentImages.count
            self.present(self.photoSolution.getPhotoPicker(maxPhotos: remainPhotos), animated: true, completion: nil)
        })
        let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        })
        alertController.addAction(takeAction)
        alertController.addAction(findAction)
        alertController.addAction(cancleAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func cancelClick(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendClick(_ sender: UIBarButtonItem) {
        editTextView.resignFirstResponder()
        if currentImages.count == 0{
            self.sendAlert(alertMessage: "Please add some photos")
        }else{
            var descriptionText = editTextView.text
            if !hasDescription || editTextView.text.count == 0{
                descriptionText = ""
            }
            progressView.isHidden = false
            self.progressView.progress = 0
            WebService.shared.uploadPost(description: descriptionText!, photos: currentImages, successHandler: {
//                self.progressView.isHidden = true
                NotificationCenter.default.post(name: NSNotification.Name("refreshData"), object: self, userInfo: ["post":"NewTest"])
                self.dismiss(animated: true, completion: nil)
            }, progressHandler: {progress in
                self.progressView.setProgress(progress, animated: true)
            }, failureHandler: { message in
                self.progressView.isHidden = true
                self.sendAlert(alertMessage: message)
            })
            
        }
    }
    
    func sendAlert(alertMessage: String){
        let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "OK", style: .cancel, handler: { action in
            UIApplication.shared.openURL(NSURL(string:UIApplication.openSettingsURLString)! as URL)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension PostViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentImages.count < maxPhotos{
            return currentImages.count + 1
        }else{
            return maxPhotos
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize ,height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pickedPhotoCollectionView!.dequeueReusableCell(withReuseIdentifier: pickerCellReuseIdentifier, for: indexPath) as! PickerCell
        cell.delegate = self
        cell.tag = indexPath.row
        if indexPath.row == currentImages.count{
            cell.imageView.image = UIImage(named: "addIcon")
            cell.deleteIcon.isHidden = true
        }else{
            cell.imageView.image = currentImages[indexPath.row]
            cell.deleteIcon.isHidden = false
        }
        return cell
    }
}

extension PostViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: space, left: space, bottom: space, right: space)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return space
    }
    
}

extension PostViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if indexPath.row == currentImages.count{
            getPhotos()
        }
    }
}

extension PostViewController: PickerCellDelegate{
    
    func deleteClick(_ cell: UICollectionViewCell) {
        currentImages.remove(at: cell.tag)
        pickedPhotoCollectionView.reloadData()
    }
    
}

extension PostViewController: PhotoSolutionDelegate{

    func returnImages(_ images: [UIImage]) {
        for image in images {
            if currentImages.count < maxPhotos{
                currentImages.append(image)
            }
        }
        //calulateImageFileSize(images.first)
        pickedPhotoCollectionView.reloadData()
    }
    
    func pickerCancel() {
        print("User close it!")
    }
    
}

extension PostViewController: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView){
        startEditTextView()
    }
    
    func textViewDidChange(_ textView: UITextView){
        if editTextView.text.count == 0{
            initTextView()
            editTextView.endEditing(true)
        }
    }

}
