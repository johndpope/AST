import CoreMotion

// MARK: ASTDeviceMotionDelegate

protocol ASTDeviceMotionDelegate {
    func orientationCorrectChanged(orientationCorrect : Bool) -> Void
}

// MARK: ASTDeviceMotion

class ASTDeviceMotion {
    // Delegate
    var motionDelegate: ASTDeviceMotionDelegate?
    
    // Variables
    let motionManager = CMMotionManager()
    var orientationCorrect: Bool = false
    // Constants
    static let rollAttitudeMax: Double = 2.0
    static let ASTdeviceUpdateInterval: TimeInterval = 0.1
    static let deviceMotionErrorMessage: String = "Error with the device motion manager."
    
    // Function sets up the motion manager
    func setupDeviceMotionManager() {
        // Check that the device motion is available
        if motionManager.isDeviceMotionAvailable {
            // Set the device motion update interval
            motionManager.deviceMotionUpdateInterval = ASTDeviceMotion.ASTdeviceUpdateInterval
            
            let queue = OperationQueue()
            motionManager.startDeviceMotionUpdates(to: queue, withHandler: { (deviceMotion, error) in
                if(error == nil) {
                    self.recievedNewDeviceMotionUpdates(deviceMotion)
                } else {
                    print(ASTDeviceMotion.deviceMotionErrorMessage)
                }
            })
        }
    }
    
    // Function gets called when the motion manager recieves new updates
    private func recievedNewDeviceMotionUpdates(_ deviceMotion: CMDeviceMotion?) {
        guard let motion = deviceMotion else {
            return
        }
        
        if self.hasDeviceOrientationChanged(motion) {
            self.motionDelegate?.orientationCorrectChanged(orientationCorrect: self.orientationCorrect)
        }
        
        ASTDeviceMotion.printAttitudesWithDeviceMotion(motion)
    }
    
    // Function checks if the device orientation has changed
    private func hasDeviceOrientationChanged(_ deviceMotion: CMDeviceMotion) -> Bool {
        let oldOrientationCorrect = orientationCorrect
        orientationCorrect = ASTDeviceMotion.isDeviceOrientatedCorrectly(deviceMotion)
        return (oldOrientationCorrect != orientationCorrect)
    }
    
    // Function checks if the device orientation is correct or incorrect
    private static func isDeviceOrientatedCorrectly(_ deviceMotion: CMDeviceMotion) -> Bool {
        return (deviceMotion.attitude.roll > ASTDeviceMotion.rollAttitudeMax || deviceMotion.attitude.roll < -ASTDeviceMotion.rollAttitudeMax)
    }
    
    // Function prints out all of the device motion attitude data
    private static func printAttitudesWithDeviceMotion(_ deviceMotion: CMDeviceMotion) {
        print("Yaw:   \(deviceMotion.attitude.yaw)")
        print("Pitch: \(deviceMotion.attitude.pitch)")
        print("Roll:  \(deviceMotion.attitude.roll)")
        print("\n")
    }
}
