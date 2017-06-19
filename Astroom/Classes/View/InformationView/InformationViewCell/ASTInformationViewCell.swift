import UIKit

@IBDesignable class ASTInformationViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    // MARK: View Methods
    override func awakeFromNib() {
        titleLabel.text = "Title"
        descriptionLabel.text = "Description"
    }
}
