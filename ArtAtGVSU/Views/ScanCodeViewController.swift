
//  QRCodeViewController.swift
//  ArtAtGVSU
//
//  Created by Kirthi Samson on 4/18/16.
//  Copyright © 2016 Kirthi Samson. All rights reserved.


import UIKit
import AVFoundation
import SwiftUI

class ScanCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    let VIEW_NAME = "QRScan"

    var captureSession:AVCaptureSession?
    var audioPlayer: AVAudioPlayer?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var scanCnt = 0
    var artworkId = ""

    @IBOutlet weak var viewPreview: UIView!

        override func viewDidLoad() {
            super.viewDidLoad()

            self.captureSession = nil
            self.loadBeepSound()

            self.qrCodeFrameView = UIView()
            if let hlv = self.qrCodeFrameView {
                hlv.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
                hlv.layer.borderColor = UIColor.orange.cgColor
                hlv.layer.borderWidth = 3
                self.viewPreview.addSubview(hlv)
            }
        }
    
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            _ = self.startReading()

        }

        func startReading() -> Bool
        {
            self.scanCnt = 0
            do {
                if let captureDevice = AVCaptureDevice.default(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video))) {
                    let input = try AVCaptureDeviceInput(device: captureDevice)
                    self.captureSession = AVCaptureSession()
                    self.captureSession?.addInput(input)
                    let captureMetadataOutput = AVCaptureMetadataOutput()
                    self.captureSession?.addOutput(captureMetadataOutput)

                    let dispatchQueue = DispatchQueue(label: "myQueue", attributes: [])
                    captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatchQueue)
                    captureMetadataOutput.metadataObjectTypes = [.qr]

                    self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
                    self.videoPreviewLayer?.videoGravity = AVLayerVideoGravity(rawValue: convertFromAVLayerVideoGravity(AVLayerVideoGravity.resizeAspectFill))
                    self.videoPreviewLayer?.frame = self.viewPreview.layer.bounds
                    self.viewPreview.layer.addSublayer(self.videoPreviewLayer!)

                    self.captureSession?.startRunning()

                }
            } catch {
                return false
            }
            return true
        }

        func stopReading()
        {
            self.captureSession?.stopRunning()
            self.captureSession = nil
        }

        // MARK: - AVCaptureMetadataOutputObjectsDelegate

        func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

            var highlightViewRect = CGRect.zero
            var barCodeObject: AVMetadataMachineReadableCodeObject

            // check if metadataObjects array is not nil and it contains at least one object.
            if !metadataObjects.isEmpty && metadataObjects.count > 0 {

                // get the metadata object
                let metadataObj = metadataObjects[0]
                if (metadataObj as AnyObject).type == convertFromAVMetadataObjectObjectType(AVMetadataObject.ObjectType.qr) {
                    barCodeObject = self.videoPreviewLayer?.transformedMetadataObject(for: metadataObj ) as! AVMetadataMachineReadableCodeObject
                    highlightViewRect = barCodeObject.bounds

                    DispatchQueue.main.async(execute: { () -> Void in
                        self.qrCodeFrameView?.frame = highlightViewRect
                        self.viewPreview .bringSubviewToFront(self.qrCodeFrameView!)
                    })
                    self.scanCnt += 1
                    if self.scanCnt > 25 {

                        self.scanCnt = 0

                        DispatchQueue.main.async(execute: { () -> Void in
                            self.stopReading()
                            }
                        )

                        if self.audioPlayer != nil {
                            self.audioPlayer?.play()
                        }

                        self.artworkId = ""
                        let url : String = (metadataObj as AnyObject).stringValue
                        //let url = metadataObj as! String
                        let parts=url.components(separatedBy: "/")
                        let partsCount = parts.count

                        if partsCount>0{
                            self.artworkId = parts[partsCount-1]
                        }
                        DispatchQueue.main.async(execute: { () -> Void in
                            if  self.artworkId == "" {
                                let alert = UIAlertController(title: "Alert", message: "Invaid QR Code. Try again.", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                                    DispatchQueue.main.async(execute: { () -> Void in
                                        _ = self.startReading()
                                    })
                                }))

                                self.present(alert, animated: true, completion: nil)

                            } else {
                                self.performSegue(withIdentifier: "ScanDetailSegue", sender: nil)
                            }
                        })
                    }

                }
            }
        }

        // MARK: - Actions and Utility methods

        @IBAction func cancelScan(_ sender: UIBarButtonItem) {
           _ = self.navigationController?.popToRootViewController(animated: true)
        }

        func loadBeepSound() {
            if let beepFilePath = Bundle.main.path(forResource: "beep", ofType: "mp3") {
                if let beepUrl = URL(string: beepFilePath) {
                    do {
                        self.audioPlayer = try AVAudioPlayer(contentsOf: beepUrl)
                    } catch {
                        // No-op
                    }
                }
            }
        }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScanDetailSegue"
        {
            let controller = segue.destination as! ArtworkDetailController
            controller.artworkID = self.artworkId
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVMediaType(_ input: AVMediaType) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVMetadataObjectObjectType(_ input: AVMetadataObject.ObjectType) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVLayerVideoGravity(_ input: AVLayerVideoGravity) -> String {
	return input.rawValue
}

struct ScanQRCodeRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ScanCodeViewController {
        return UIStoryboard.mainStoryboardInstance(withIdentifier: "QRCodeScanner")
    }

    func updateUIViewController(_ uiViewController: ScanCodeViewController, context: Context) {
    }
}
