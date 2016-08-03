//
//  BarcodeReaderViewController.swift
//  CDBarcodes
//
//  Created by Matthew Maher on 1/29/16.
//  Copyright © 2016 Matt Maher. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
	
	var session: AVCaptureSession!
	var previewLayer: AVCaptureVideoPreviewLayer!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		session = AVCaptureSession()
		
		let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
		
		let videoInput: AVCaptureDeviceInput?
		
		do {
			videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
		} catch {
			return
		}
		
		if (session.canAddInput(videoInput)) {
			session.addInput(videoInput)
		} else {
			scanningNotPossible()
		}
		
		let metadataOutput = AVCaptureMetadataOutput()
		
		if (session.canAddOutput(metadataOutput)) {
			session.addOutput(metadataOutput)
			
			metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
			metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code]
		} else {
			scanningNotPossible()
		}
		
		previewLayer = AVCaptureVideoPreviewLayer(session: session)
		previewLayer.frame = view.layer.bounds
		previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
		view.layer.addSublayer(previewLayer)
		
		session.startRunning()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		if (session?.running == false) {
			session.startRunning()
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		if (session?.running == true) {
			session.stopRunning()
		}
	}
	
	func scanningNotPossible() {
		let alert = UIAlertController(title: "摄像头无法识别或获取", message: "请更换为有摄像头的设备", preferredStyle: .Alert)
		alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
		presentViewController(alert, animated: true, completion: nil)
		session = nil
	}
	
	func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
		if let barCodeData = metadataObjects.first {
			let barcodeReadable = barCodeData as? AVMetadataMachineReadableCodeObject
			if let readableCode = barcodeReadable {
				barcodeDetected(readableCode.stringValue)
			}
			
			AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
			
			session.stopRunning()
		}
	}
	
	func barcodeDetected(code: String) {
		let alert = UIAlertController(title: "找到一个Barcode", message: code, preferredStyle: .Alert)
		alert.addAction(UIAlertAction(title: "Search", style: .Destructive, handler: { action in
			let trimmedCode = code.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
			
			let trimmedCodeString = "\(trimmedCode)"
			var trimmedCodeNoZero: String
			
			if (trimmedCodeString.hasPrefix("0") && trimmedCodeString.characters.count > 1) {
				trimmedCodeNoZero = String(trimmedCodeString.characters.dropFirst())
				
				DataService.searchAPI(trimmedCodeNoZero)
			} else {
				DataService.searchAPI(trimmedCodeString)
			}
			
			self.navigationController?.popViewControllerAnimated(true)
			})
		)
		self.presentViewController(alert, animated: true, completion: nil)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
	}
}
