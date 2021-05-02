//
//  QRViewController.swift
//  Marketplace
//
//  Created by Ilshat Khairakhun on 02.05.2021.
//

import UIKit
import AVFoundation

class QRViewController: UIViewController {
    
    let popUp = TrackingPopUpView()
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var squareView: SquareView?
    
    //:TODO Fix text lable when wrong qr
//    let bottomLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Неверный код!"
//        label.backgroundColor = .red
//        label.layer.cornerRadius = 14
//        label.layer.masksToBounds = true
//        return label
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        setupPopUp()
        getBackCam()
        
    }
    
    func getBackCam() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)

        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }

        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)

            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession.startRunning()
            
            //Adding my View
            createCornerFrame()
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    func createCornerFrame() {
        let width: CGFloat = 400.0
        let height: CGFloat = 400.0
        
        let rect = CGRect.init(
            origin: CGPoint.init(
                x: self.view.frame.midX - width/2,
                y: self.view.frame.midY - (width+80)/2),
            size: CGSize.init(width: width, height: height))
        self.squareView = SquareView(frame: rect)
        if let squareView = squareView {
            self.view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            squareView.autoresizingMask = UIView.AutoresizingMask(rawValue: UInt(0.0))
            self.view.addSubview(squareView)
            
            addMaskLayerToVideoPreviewLayerAndAddText(rect: rect)
        }
    }
    
    func addMaskLayerToVideoPreviewLayerAndAddText(rect: CGRect) {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.fillColor = UIColor(white: 0.0, alpha: 0.5).cgColor
        let path = UIBezierPath(rect: rect)
        path.append(UIBezierPath(rect: view.bounds))
        maskLayer.path = path.cgPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        view.layer.insertSublayer(maskLayer, above: videoPreviewLayer)
    
    }
    
    func setupPopUp() {
        view.addSubview(popUp)
        popUp.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            popUp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popUp.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popUp.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 20),
            popUp.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    
}

extension QRViewController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            //qrCodeFrameView?.frame = CGRect.zero
            //messageLabel.text = "No QR code is detected"
            return
        }

        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            //qrCodeFrameView?.frame = barCodeObject!.bounds

            if metadataObj.stringValue != nil {
                view.bringSubviewToFront(popUp)
               // messageLabel.text = metadataObj.stringValue
            }
        }
    }

}
