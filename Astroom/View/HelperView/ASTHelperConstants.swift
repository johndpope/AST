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
}
