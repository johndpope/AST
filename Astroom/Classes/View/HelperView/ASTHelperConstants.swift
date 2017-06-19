import UIKit

class ASTHelperConstants {
    // No Warning
    static let noWarning = HelpViewModel(image: nil,
                                                  title: "",
                                                  description: "")
    // Orientation Warning
    static let orientationWarning = HelpViewModel(image: UIImage(named: "ic_attention"),
                                                  title: "Orientation Warning",
                                                  description: "Please tilt your device towards the ceiling")
    
    // Session Interrupted
    static let sessionInterrupted = HelpViewModel(image: UIImage(named: "ic_attention"),
                                                  title: "Session Interrupted",
                                                  description: "The session will be reset after the interruption has ended.")
}
