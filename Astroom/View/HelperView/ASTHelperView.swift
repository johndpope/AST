import UIKit

// MARK: ASTHelperView

class ASTHelperView : UIView {
    
    // Outlets
    @IBOutlet var helperImageView: UIImageView!
    @IBOutlet var helperTitleLabel: UILabel!
    @IBOutlet var helperDescriptionLabel: UILabel!
    
    // MARK: View Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    // MARK: Format Methods
    
    func formatHelperViewForMessage(_ helperViewMessageDetails: HelpViewModel) {
        DispatchQueue.main.async {
            self.helperImageView.image = helperViewMessageDetails.image
            self.helperTitleLabel.text = helperViewMessageDetails.title
            self.helperDescriptionLabel.text = helperViewMessageDetails.description
            
            self.animateInView()
        }
    }
    
    func formatHelperViewForNoMessage() {
        DispatchQueue.main.async {
            self.helperImageView.image = ASTHelperConstants.noWarning.image
            self.helperTitleLabel.text = ASTHelperConstants.noWarning.title
            self.helperDescriptionLabel.text = ASTHelperConstants.noWarning.description
            
            self.animateOutView()
        }
    }
    
    // MARK: Helper Methods
    
    private func animateInView() {
        UIView.animate(withDuration: ASTUIConstants.shortAnimationDuration, animations: {
            self.alpha = 1.0
        })
    }
    
    private func animateOutView() {
        UIView.animate(withDuration: ASTUIConstants.shortAnimationDuration, animations: {
            self.alpha = 0.0
        })
    }
}
