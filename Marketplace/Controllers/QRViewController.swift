//
//  QRViewController.swift
//  Marketplace
//
//  Created by Ilshat Khairakhun on 02.05.2021.
//

import UIKit
import AVFoundation
import Alamofire
import ProgressHUD

class QRViewController: UIViewController {
    
    let popUpView = TrackingPopUpView()
    let squareView = SquareView()
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    //var squareView: SquareView?
    
    private var invoiceNum: String?
    private var orderNo: String?
    
    private let headers: HTTPHeaders = [
        "Authorization": "Basic Y2tfMGQ5NGZjMmQ2ZmQxYWU4NjViNWY5ZjVlNTA3MThlNmVmMmZhMDM5MDpjc18yZmJkNmM3ZDU3Y2M3Yjg4Y2FlMDlkZmIzZWU5ZGYzZjlkMTE2YjM3="
    ]
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Отсканируйте код"
        label.backgroundColor = .clear
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.viewDelegate = self
        
        setupPopUp()
        getBackCam()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func setupLabels() {
        view.addSubview(topLabel)
        
        NSLayoutConstraint.activate([
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            topLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
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
    
    func getOrderInfo() {
        
        guard let orderNumber = orderNo else { return }
        
        let orderUrl = APIUrls.generatedOrderUrl + "/\(orderNumber)"
        
        ProgressHUD.show()
        NetworkManager.shared.request(url: orderUrl, method: .get, headers: headers) { (result: Result<TrackingModel, ErrorModel>) in
            ProgressHUD.dismiss()
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
    
    func changeOrderStatus() {
        
        guard let orderNumber = orderNo else { return }
        
        NetworkManager.shared.request(url: APIUrls.generatedOrderUrl + orderNumber + APIUrls.statusComplete, method: .put) { (result: Result<TrackingModel, ErrorModel>) in
            switch result {
            case .failure(let error):
                self.showAlert(alertText: "Ошибка", alertMessage: error.message)
                self.captureSession.startRunning()
            case .success(let trackingModel):
                let status = trackingModel.status
                if status == "completed" {
                    self.showAlert(alertText: "Вы приняли заказ!", alertMessage: "Вы приняли заказ!")
                    self.view.sendSubviewToBack(self.popUpView)
                    self.captureSession.startRunning()
                }
            }
        }
        
    }
    
}
//MARK: RectangleViewSetup
extension QRViewController {
    
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
    
    func createCornerFrame() {
//        let width: CGFloat = 280.0
//        let height: CGFloat = 280.0
//
//        let rect = CGRect.init(
//            origin: CGPoint.init(
//                x: self.view.frame.midX - width/2,
//                y: self.view.frame.midY - (width+80)/2),
//            size: CGSize.init(width: width, height: height))
//        self.squareView = SquareView(frame: rect)
//        if let squareView = squareView {
//            self.view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
//            squareView.autoresizingMask = UIView.AutoresizingMask(rawValue: UInt(0.0))
//            self.view.addSubview(squareView)
//
//            addMaskLayerToVideoPreviewLayerAndAddText(rect: rect)
//        }
        
        view.addSubview(squareView)
        squareView.translatesAutoresizingMaskIntoConstraints = false
        squareView.layer.cornerRadius = 2
        squareView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            squareView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            squareView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            squareView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),
            squareView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ])
        
        addMaskLayerToVideoPreviewLayerAndAddText(rect: squareView.bounds)
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
                    orderNo = order[1].trimmingCharacters(in: .whitespaces)
                    getOrderInfo()
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
        self.view.sendSubviewToBack(self.popUpView)
        self.captureSession.startRunning()
    }
}
