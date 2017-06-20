import UIKit

class ASTHelperConstants {
    
    // MARK: Tracking States
    
    // Tracking State Not Available
    static let trackingStateNotAvailable = ASTHelpViewModel(image: UIImage(named: "ic_attention"),
                                                            title: "Tracking State - Not Available",
                                                            description: "The session tracking state is unavailable")
    
    // Tracking State Limited
    static let trackingStateLimited = ASTHelpViewModel(image: UIImage(named: "ic_attention"),
                                                       title: "Tracking State - Limited",
                                                       description: "The session is in a limited state")
    
    // Tracking State Normal
    static let trackingStateNormal = ASTHelpViewModel(image: UIImage(named: "ic_attention"),
                                                      title: "Tracking State - Normal",
                                                      description: "The session is running normally.")
    
    // MARK: Warnings
    
    // Orientation Warning
    static let orientationWarning = ASTHelpViewModel(image: UIImage(named: "ic_attention"),
                                                  title: "Orientation Warning",
                                                  description: "Please tilt your device towards the ceiling")
    
    // Memory Warning
    static let memoryWarning = ASTHelpViewModel(image: UIImage(named: "ic_attention"),
                                                   title: "Memory Warning",
                                                   description: "Device is running out of memory")
    
    // MARK: Session States
    
    // Starting New Session
    static let newSession = ASTHelpViewModel(image: UIImage(named: "ic_attention"),
                                             title: "Starting a New Session",
                                             description: "Preparing a new session")
    
    // Session Interrupted
    static let sessionInterrupted = ASTHelpViewModel(image: UIImage(named: "ic_attention"),
                                                     title: "Session Interrupted",
                                                     description: "The session will be reset after the interruption has ended.")
    // MARK: Misc
    
    // No Warning
    static let noWarning = ASTHelpViewModel(image: nil,
                                            title: "",
                                            description: "")
}
