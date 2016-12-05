//
//  ViewController.swift
//  VideoFrameProcessDemo
//
//  Created by Xiomar on 2016-11-22.
//  Copyright © 2016 Xiomar. All rights reserved.
//

import Cocoa
import AVFoundation

let defaultCameraKey = "defaultcamera"

class ViewController: NSViewController, VideoSourceDelegate {

    
    @IBOutlet weak var inputFrame: NSImageView!
    @IBOutlet weak var processedFrame: NSImageView!
    
    @IBOutlet weak var cameraSelectionBtn: NSPopUpButton!
    @IBOutlet weak var videoPathField: NSTextField!
    
    var deviceNames = [String]()  // save camera devices
    var cameraIndex = UserDefaults.standard.integer(forKey: defaultCameraKey)
    
    let wrapper = CVWrapper.sharedWrapper() as AnyObject
    var videoSource = VideoSource()
    var cameraIsOn = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize device list
        self.cameraSelectionBtn.removeAllItems()
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        for device in devices! {
            deviceNames.append((device as! AVCaptureDevice).localizedName)
            self.cameraSelectionBtn.addItem(withTitle: (device as! AVCaptureDevice).localizedName)
        }
        self.cameraSelectionBtn.setTitle(self.deviceNames.first!)
        self.videoSource.delegate = self
    }
    override func viewDidAppear() {
        if self.deviceNames.count == 1 {
            self.cameraSelectionBtn.setTitle(self.deviceNames.first!)
        } else if self.cameraIndex < self.deviceNames.count {
            self.cameraSelectionBtn.setTitle(self.deviceNames[self.cameraIndex])
        } else {
            self.cameraIndex = 0
            UserDefaults.standard.set(0, forKey: defaultCameraKey)
        }
    }

    @IBAction func cameraSelectionUpdated(_ sender: NSPopUpButton) {
        self.cameraSelectionBtn.setTitle(sender.selectedItem!.title)
        self.cameraIndex = sender.index(of: sender.selectedItem!)
        UserDefaults.standard.set(self.cameraIndex, forKey: defaultCameraKey)
    }
    @IBAction func cameraOn(_ sender: NSButton) {
        if !self.cameraIsOn {
            let started = self.videoSource.startCamera()
            if started {
                self.cameraIsOn = true
            }
        }
    }
    @IBAction func cameraOff(_ sender: NSButton) {
        self.videoSource.stop()
    }

    @IBAction func videoOn(_ sender: NSButton) {
    }
    @IBAction func videoOff(_ sender: NSButton) {
    }
    
    func frameReady(_ imageBuffer: CVImageBuffer) {
        
        self.wrapper.processFrameBuffer(imageBuffer)
        let inputImg = self.wrapper.getOriginalImg()
        let outputImg = self.wrapper.getOutputImg()
//        let maxes = CVWrapper.sharedWrapper().getSettingMaxes()
//        let red = maxes % 1000
//        let green = (maxes / 1000) % 1000
//        let blue = maxes / 1000000
//        self.logLabel.stringValue = "Blue max = \(blue) Green max = \(green) Red max = \(red)"
        DispatchQueue.main.async {
            self.inputFrame.image = inputImg
            self.processedFrame.image = outputImg
        }
    }
}

