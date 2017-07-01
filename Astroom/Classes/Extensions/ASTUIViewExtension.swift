import UIKit

extension UIView {
    // Performs the initial setUp
    func setUpView() {
        let view = viewFromNibForClass()
        view.frame = self.bounds
        
        view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        
        addSubview(view)
    }
    
    // Loads a XIB file into a view and returns this view
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}

