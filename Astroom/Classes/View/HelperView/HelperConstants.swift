import UIKit

class HelperConstants {
    
    // MARK: Tracking States
    
    // Tracking State Not Available
    static let trackingStateNotAvailable = HelpViewModel(image: UIImage(named: "ic_high_warning"),
                                                            title: "Tracking State - Not Available",
                                                            description: "The session tracking state is unavailable")
    
    // Tracking State Limited
    static let trackingStateLimited = HelpViewModel(image: UIImage(named: "ic_attention"),
                                                       title: "Tracking State - Limited",
                                                       description: "The session is in a limited state")
    
    // Tracking State Normal
    static let trackingStateNormal = HelpViewModel(image: UIImage(named: "ic_info"),
                                                      title: "Tracking State - Normal",
                                                      description: "The session is running normally.")
    
    // MARK: Warnings
    
    // Orientation Warning
    static let orientationWarning = HelpViewModel(image: UIImage(named: "ic_attention"),
                                                  title: "Orientation Warning",
                                                  description: "Please tilt your device towards the ceiling")
    
    // Memory Warning
    static let memoryWarning = HelpViewModel(image: UIImage(named: "ic_attention"),
                                                   title: "Memory Warning",
                                                   description: "Device is running out of memory")
    
    // MARK: Session States
    
    // Starting New Session
    static let newSession = HelpViewModel(image: UIImage(named: "ic_info"),
                                             title: "Starting a New Session",
                                             description: "Preparing a new session")
    
    // Session Interrupted
    static let sessionInterrupted = HelpViewModel(image: UIImage(named: "ic_attention"),
                                                     title: "Session Interrupted",
                                                     description: "The session will be reset after the interruption has ended.")
    
    // MARK: Instructions
    
    // Starting instruction
    static let startingInstruction = HelpViewModel(image: UIImage(named: "ic_info"),
                                                      title: "Get Started",
                                                      description: "Point devices camera at a flat surface, such as a table")
    
    // MARK: Misc
    
    // No Warning
    static let noWarning = HelpViewModel(image: nil,
                                            title: "",
                                            description: "")
}
