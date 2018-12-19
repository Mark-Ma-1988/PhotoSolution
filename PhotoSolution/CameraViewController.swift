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
    
    @IBOutlet weak var topNativationBar: UINavigationBar!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var rotateButton: UIBarButtonItem!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func closeButtonClick(_ sender: UIBarButtonItem) {
        self.solutionDelegate?.pickerCancel()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rotateButtonClick(_ sender: UIBarButtonItem) {
        if(currentCaptureDevice == frontCamera){
            setupInput(isBackCamera: true)
        }else{
            setupInput(isBackCamera: false)
        }
    }
    
    @IBAction func cameraClick(_ sender: UIButton) {
        self.cameraButton.isEnabled = false
        self.stillImageOutput.captureStillImageAsynchronously(from: self.stillImageOutput.connection(with: AVMediaType.video)!) { (buffer, error) in
            if buffer == nil {
                return
            }else{
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer!)
                let image = UIImage(data: imageData!)
//                [self.session stopRunning];
//                [self.view addSubview:self.cameraImageView];
//                let imgData = data_image?.jpegData(compressionQuality: 0.01)
//                let imageForSave = UIImage(data: imgData!)
                //
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image!)
                }) { (isSuccess: Bool, error: Error?) in
                    if isSuccess {
                        DispatchQueue.main.async{
                            self.cameraButton.isEnabled = true
                        }
                    } else{
                        print("save fail", error!.localizedDescription)
                    }
                }
                
                
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
