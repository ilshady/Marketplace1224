//
//  QRViewController.swift
//  Marketplace
//
//  Created by Ilshat Khairakhun on 02.05.2021.
//

import UIKit
import AVFoundation
import MKProgress
import Alamofire

class QRViewController: UIViewController {
    
    let popUpView = TrackingPopUpView()
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var squareView: SquareView?
    
    var invoiceNum: String?
    
    //:TODO Fix text lable when wrong qr
//    let bottomLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Вы приняли заказ!"
//        label.backgroundColor = .red
//        label.layer.cornerRadius = 14
//        label.layer.masksToBounds = true
//        return label
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.viewDelegate = self
        
        setupPopUp()
        getBackCam()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func getBackCam() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)

        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)

            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession.startRunning()
            
            createCornerFrame()
            
        } catch {
            print(error)
            return
        }
    }
    
    func setupPopUp() {
        view.addSubview(popUpView)
        popUpView.translatesAutoresizingMaskIntoConstraints = false
        popUpView.layer.cornerRadius = 2
        popUpView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            popUpView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popUpView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),
            popUpView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ])
    }
    
    func getOrderInfo(orderNo: String) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic Y2tfMGQ5NGZjMmQ2ZmQxYWU4NjViNWY5ZjVlNTA3MThlNmVmMmZhMDM5MDpjc18yZmJkNmM3ZDU3Y2M3Yjg4Y2FlMDlkZmIzZWU5ZGYzZjlkMTE2YjM3="
        ]
        
        MKProgress.show()
        NetworkManager.shared.request(url: APIUrls.generatedOrderUrl + orderNo, method: .get, headers: headers) { (result: Result<TrackingModel, ErrorModel>) in
            MKProgress.hide()
            switch result {
            case .failure(let error):
                self.showAlert(alertText: "Ошибка", alertMessage: error.message)
            case .success(let trackingModel):
                let metaData = trackingModel.metaData
                if let invoiceNumber = metaData.first(where: {$0.key == "wf_invoice_number"})?.value {
                    self.invoiceNum = invoiceNumber
                    self.view.bringSubviewToFront(self.popUpView)
                }
            }
        }
    }
    
}
//MARK: RectangleViewSetup
extension QRViewController {
    
    func createCornerFrame() {
        let width: CGFloat = 300.0
        let height: CGFloat = 300.0
        
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
}
//MARK: AVCaptureMetadataOutputObjectsDelegate
extension QRViewController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            
            if let response = metadataObj.stringValue {
                if response.contains("Номер заказа") {
                    self.captureSession.stopRunning()
                    let responseArray = response.split(separator: ",")
                    let order = responseArray[0].split(separator: ":")
                    let orderNo = order[1].trimmingCharacters(in: .whitespaces)
                    getOrderInfo(orderNo: String(orderNo))
                }
            }
        }
    }

}
//MARK: TrackingPopUpDelegate
extension QRViewController: TrackingPopUpViewDelegate {
    func checkButtonPressed() {
        if popUpView.trackingInputTextField.text == invoiceNum {
            self.showAlert(alertText: "Вы приняли заказ!", alertMessage: "Вы приняли заказ!")
        } else {
            self.showAlert(alertText: "Try again!", alertMessage: "Again try!")
        }
        view.sendSubviewToBack(popUpView)
        captureSession.startRunning()
    }
}
