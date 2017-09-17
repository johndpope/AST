import UIKit

// MARK: LandingViewController

class LandingViewController : UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var copyRightLabel: UILabel!
    @IBOutlet var starOneImage: UIImageView!
    @IBOutlet var starTwoImage: UIImageView!
    @IBOutlet var starThreeImage: UIImageView!
    
    // MARK: View Methods
    
    override func viewDidLoad() {
        fadeOutLabels()
        animateInStars()
    }
    
    // MARK: Outlets
    
    func fadeOutLabels() {
        UIView.animate(withDuration: UIConstants.shortAnimationDuration) {
            self.nameLabel.alpha = 0.0
            self.copyRightLabel.alpha = 0.0
        }
    }
    
    func animateInStars() {
        animateStarOne()
        animateStarTwo()
        animateStarThree()
    }
    
    private func animateStarOne() {
        UIView.animate(withDuration: UIConstants.mediumAnimationDuration, delay: UIConstants.shortAnimationDuration, options: .curveEaseIn, animations: {
            self.starOneImage.frame.origin.x += self.view.frame.width * 1.6
            self.starOneImage.frame.origin.y += self.view.frame.height / 1.9
        })
    }
    
    private func animateStarTwo() {
        UIView.animate(withDuration: UIConstants.mediumAnimationDuration, delay: UIConstants.mediumAnimationDuration, options: .curveEaseIn, animations: {
            self.starOneImage.frame.origin.x += self.view.frame.width * 1.4
            self.starOneImage.frame.origin.y += self.view.frame.height / 1.8
        })
    }
    
    private func animateStarThree() {
        UIView.animate(withDuration: UIConstants.longAnimationDuration, delay: UIConstants.longAnimationDuration, options: .curveEaseIn, animations: {
            self.starOneImage.frame.origin.x += self.view.frame.width * 1.5
            self.starOneImage.frame.origin.y += self.view.frame.height / 2.2
        })
        
        UIView.animate(withDuration: UIConstants.longAnimationDuration, delay: UIConstants.longAnimationDuration, options: .curveEaseIn, animations: {
            self.starOneImage.frame.origin.x += self.view.frame.width * 2.0
            self.starOneImage.frame.origin.y += self.view.frame.height / 2.2
        })
    }
}
