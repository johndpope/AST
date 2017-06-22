import UIKit

// MARK: ASTHelperView

class ASTHelperView : UIView {
    
    // Outlets
    @IBOutlet var helperImageView: UIImageView!
    @IBOutlet var helperTitleLabel: UILabel!
    @IBOutlet var helperDescriptionLabel: UILabel!
    var blurEffectView: UIVisualEffectView!
    
    private var isVisible: Bool {
        return self.alpha > 0
    }
    
    // MARK: View Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
        
    // MARK: Format Methods
    
    /// Formatter takes an ASTHelpViewModel and sets appropriate properties
    func formatHelperViewForMessage(_ helperViewMessageDetails: ASTHelpViewModel) {
        if !isVisible {
            DispatchQueue.main.async {
                self.helperImageView.image = helperViewMessageDetails.image
                self.helperTitleLabel.text = helperViewMessageDetails.title
                self.helperDescriptionLabel.text = helperViewMessageDetails.description
                
                self.animateInView()
                
                // Fade out the helper view after user has read
                let duration = self.calculateDisplayDuration(helperViewMessageDetails)
                DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: {
                    self.animateOutView()
                })
            }
        }
    }
    
    /// Formatter sets appropriate properties to nil
    func formatHelperViewForNoMessage() {
        DispatchQueue.main.async {
            self.helperImageView.image = ASTHelperConstants.noWarning.image
            self.helperTitleLabel.text = ASTHelperConstants.noWarning.title
            self.helperDescriptionLabel.text = ASTHelperConstants.noWarning.description
            
            self.animateOutView()
        }
    }
    
    // MARK: Helper Methods
    
    private func calculateDisplayDuration(_ helperMessage: ASTHelpViewModel) -> TimeInterval {
        // Compute an appropriate amount of time to display the on screen message.
        // According to https://en.wikipedia.org/wiki/Words_per_minute, adults read
        // about 200 words per minute and the average English word is 5 characters
        // long. So 1000 characters per minute / 60 = 15 characters per second.
        // We limit the duration to a range of 1-6 seconds.
        let charCount = helperMessage.title.characters.count + helperMessage.description.characters.count
        return min(6, Double(charCount) / 15.0 + 1.0) as TimeInterval
    }
    
    private func animateInView() {
        UIView.animate(withDuration: ASTUIConstants.shortAnimationDuration, animations: {
            self.addBlurEffectView()
            self.alpha = 1.0
        })
    }
    
    private func animateOutView() {
        UIView.animate(withDuration: ASTUIConstants.shortAnimationDuration, animations: {
            self.alpha = 0.0
        }, completion: { (finished: Bool) in
            self.removeBlurEffectView()
        })
    }
}
