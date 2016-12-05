import Cocoa
import AVFoundation

protocol VideoSourceDelegate {
    func frameReady(_ newFrame: CVImageBuffer)
}

class VideoSource: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var captureSession = AVCaptureSession()
    var deviceInput = AVCaptureDeviceInput()
    var delegate : VideoSourceDelegate?
    
    override init() {
        super.init()
        if captureSession.canSetSessionPreset(AVCaptureSessionPreset320x240) {
            captureSession.sessionPreset = AVCaptureSessionPreset320x240
            NSLog("capturing video at 640 x 480")
        } else {
            NSLog("Could not configure AVCaptureSession Video Input")
        }
    }
    
    // MARK: API
    func startCamera() -> Bool {
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        let cameraIndex = UserDefaults.standard.integer(forKey: "defaultcamera")
        let videoDevice = devices![cameraIndex] as? AVCaptureDevice
        if videoDevice == nil {
            NSLog("could not initialize camera")
            return false
        }
        do {
            self.deviceInput = try AVCaptureDeviceInput(device: videoDevice)
        } catch {
            NSLog("could not open input port for device \(videoDevice)")
            return false
        }
        if self.captureSession.canAddInput(self.deviceInput) {
            self.captureSession.addInput(self.deviceInput)
        } else {
            NSLog("could not add input port for capture session \(self.captureSession)")
            return false
        }
        self.addVideoDataOutput()
        self.captureSession.startRunning()
        return true
    }
    func stop() {
        self.captureSession.stopRunning()
    }
    
    // MARK: Helper
    
    func addVideoDataOutput() {
        let captureOutput = AVCaptureVideoDataOutput()
        captureOutput.alwaysDiscardsLateVideoFrames = true
        let queue = DispatchQueue(label: "com.clarke.CVDemo", attributes: [])
        captureOutput.setSampleBufferDelegate(self, queue: queue)
        let key = kCVPixelBufferPixelFormatTypeKey
        let value = NSNumber(value: kCVPixelFormatType_32BGRA as UInt32)
        captureOutput.videoSettings = [key as AnyHashable:value]
        self.captureSession.addOutput(captureOutput)
    }
    
    // MARK: sample buffer delegate
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            NSLog("failed to get cvimagebuffer from smsamplebuffer")
            return
        }
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags.readOnly)
        self.delegate!.frameReady(imageBuffer)
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
    }
}
