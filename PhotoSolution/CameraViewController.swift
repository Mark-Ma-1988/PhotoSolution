//
//  CameraViewController.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 13/12/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController {
    
    var solutionDelegate:PhotoSolutionDelegate?
    var customization: PhotoSolutionCustomization!
    var podBundle: Bundle!
    var inCameraView: Bool!
    var imageEditView: ImageEditView!
   
    @IBOutlet weak var rotateCameraButton: UIImageView!
    @IBOutlet weak var cancelCameraButton: UIImageView!
    @IBOutlet weak var takePhotoButton: UIImageView!
    
    @IBOutlet weak var cameraArea: UIView!
    
    var captureSession: AVCaptureSession!
    var currentCaptureDevice: AVCaptureDevice!
    var frontCamera: AVCaptureDevice!
    var backCamera: AVCaptureDevice!
    var stillImageOutput: AVCaptureStillImageOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    func setupFrontAndBackCamera(){
        if let devices = AVCaptureDevice.devices(for: AVMediaType.video) as [AVCaptureDevice]? {
            for device in devices {
                if(device.position == AVCaptureDevice.Position.back) {
                    backCamera = device
                }else if(device.position == AVCaptureDevice.Position.front){
                    frontCamera = device
                }
            }
            currentCaptureDevice = backCamera
        }
    }
    
    func setupSessionAndOutput(){
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        stillImageOutput = AVCaptureStillImageOutput()
        //stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }else{
            //Todo
        }
        
        if let connection = self.stillImageOutput.connection(with: AVMediaType.video) {
            if (self.currentCaptureDevice?.activeFormat.isVideoStabilizationModeSupported(.auto))! {
                connection.preferredVideoStabilizationMode = .auto
            }
        }
        
    }
    
    func setupInput(isBackCamera: Bool){
        do {
            self.captureSession.beginConfiguration()
            if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
                for input in inputs {
                    captureSession.removeInput(input)
                }
            }
            if(isBackCamera){
                currentCaptureDevice = backCamera
            }else{
                currentCaptureDevice = frontCamera
            }
            try self.captureSession.addInput(AVCaptureDeviceInput(device: self.currentCaptureDevice))
            self.captureSession.commitConfiguration()
        } catch {
            print("Error")
        }
    }
    
    func setupPreviewLayer(){
        self.cameraArea.backgroundColor = UIColor.red
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.cameraArea.layer.masksToBounds = true
        self.previewLayer?.frame = self.cameraArea.bounds
        self.previewLayer?.position = CGPoint(x: self.cameraArea.bounds.midX, y: self.cameraArea.bounds.midY)
        // [previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
        self.cameraArea.layer.addSublayer(self.previewLayer!)
    }
    
    func setupUI(){
        rotateCameraButton.image = UIImage(named: "switchIcon")
        takePhotoButton.image = UIImage(named: "cameraIcon")
        cancelCameraButton.image = UIImage(named: "cancelIcon")
        
        let tapRotateCameraButtonRecognizer = UITapGestureRecognizer(target: self, action: #selector(rotateCameraButtonTapped(tapGestureRecognizer:)))
        rotateCameraButton.isUserInteractionEnabled = true
        rotateCameraButton.addGestureRecognizer(tapRotateCameraButtonRecognizer)
        
        let tapCancelCameraButtonRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelCameraButtonTapped(tapGestureRecognizer:)))
        cancelCameraButton.isUserInteractionEnabled = true
        cancelCameraButton.addGestureRecognizer(tapCancelCameraButtonRecognizer)
        
        let tapTakePhotoButtonRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapTakePhotoButtonRecognizer(tapGestureRecognizer:)))
        takePhotoButton.isUserInteractionEnabled = true
        takePhotoButton.addGestureRecognizer(tapTakePhotoButtonRecognizer)
        
        let frameworkBundle = Bundle(for: PhotoSolution.self)
        let url = frameworkBundle.resourceURL!.appendingPathComponent("PhotoSolution.bundle")
        podBundle = Bundle(url: url)
        imageEditView = UINib(nibName: "ImageEditView", bundle: self.podBundle).instantiate(withOwner: nil, options: nil)[0] as? ImageEditView
    }
    
    @objc func rotateCameraButtonTapped(tapGestureRecognizer: UITapGestureRecognizer){
        if(currentCaptureDevice == frontCamera){
            setupInput(isBackCamera: true)
        }else{
            setupInput(isBackCamera: false)
        }
    }
    
    @objc func cancelCameraButtonTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.solutionDelegate?.pickerCancel()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tapTakePhotoButtonRecognizer(tapGestureRecognizer: UITapGestureRecognizer){
        self.stillImageOutput.captureStillImageAsynchronously(from: self.stillImageOutput.connection(with: AVMediaType.video)!) { (buffer, error) in
            //self.cameraButton.isEnabled = true
            if buffer == nil {
                return
            }else{
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer!)
                let image = UIImage(data: imageData!)
                self.imageEditView.frame = self.cameraArea.frame
                self.imageEditView.setupImage(edittingImage: image!, fromCamera: true)
                self.imageEditView.delegate = self
                self.view.addSubview(self.imageEditView)
                self.inCameraView = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inCameraView = true
        setupUI()
        setupFrontAndBackCamera()
        setupSessionAndOutput()
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .authorized:
                        self.setupInput(isBackCamera: true)
                    case .denied, .restricted:
                        self.goToPhotoAccessSetting()
                    case .notDetermined:
                        self.goToPhotoAccessSetting()
                    }
                }
            } else {
                self.goToCameraAccessSetting()
            }
        }
        setupPreviewLayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (captureSession.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if (captureSession.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func goToPhotoAccessSetting(){
        let alert = UIAlertController(title: nil, message: customization.alertTextForPhotoAccess, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: customization.settingButtonTextForPhotoAccess, style: .cancel, handler: { action in
            UIApplication.shared.openURL(NSURL(string:UIApplication.openSettingsURLString)! as URL)
        }))
        alert.addAction( UIAlertAction(title: customization.cancelButtonTextForPhotoAccess, style: .default, handler: { action in
            self.solutionDelegate?.pickerCancel()
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToCameraAccessSetting(){
        let alert = UIAlertController(title: nil, message: self.customization.alertTextForCameraAccess, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: self.customization.settingButtonTextForCameraAccess, style: .cancel, handler: { action in
            UIApplication.shared.openURL(NSURL(string:UIApplication.openSettingsURLString)! as URL)
        }))
        alert.addAction( UIAlertAction(title: self.customization.cancelButtonTextForCameraAccess, style: .default, handler: { action in
            self.solutionDelegate?.pickerCancel()
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension CameraViewController: ImageEditViewDelegate{
    
    func imageCompleted(_ editedImage: UIImage) {
        self.solutionDelegate?.returnImages([editedImage])
        self.dismiss(animated: true, completion: nil)
    }
        
}
