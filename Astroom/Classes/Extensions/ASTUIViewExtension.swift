import UIKit

extension UIView {
    // Performs the initial setUp
    func setUpView() {
        let view = viewFromNibForClass()
        view.frame = self.bounds
        
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        addSubview(view)
    }
    
    /// Adds blur effect to the background of the view
    func addBlurEffectView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.tag = ASTUIConstants.blurEffectViewTag
        addSubview(blurEffectView)
        sendSubview(toBack: blurEffectView)
    }
    
    /// Removes blur effect from the background of the view
    func removeBlurEffectView() {
        let blurEffectViewOptional = subviews.filter{$0.tag == ASTUIConstants.blurEffectViewTag}.first
        guard let blurEffectView = blurEffectViewOptional else {
            return
        }
        blurEffectView.removeFromSuperview()
    }
    
    // MARK: Helper Methods
    
    /// Loads a XIB file into a view and returns this view
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}

