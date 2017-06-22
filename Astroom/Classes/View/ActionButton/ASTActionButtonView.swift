import UIKit

class ASTActionButtonView : UIView {
    
    @IBOutlet var actionButtonImage: UIImageView!
    @IBOutlet var actionButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        self.addBlurEffectView()
    }
}
