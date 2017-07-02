import UIKit

class ASTInfoController : UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet var collectionView: UICollectionView!
    var planetArray: [UIImage] = [#imageLiteral(resourceName: "MercuryImage"),#imageLiteral(resourceName: "VenusImage"),#imageLiteral(resourceName: "EarthImage"),#imageLiteral(resourceName: "MarsImage"),#imageLiteral(resourceName: "JupiterImage"),#imageLiteral(resourceName: "SaturnImage"),#imageLiteral(resourceName: "UranusImage"),#imageLiteral(resourceName: "NeptuneImage"),#imageLiteral(resourceName: "PlutoImage")]
    
    
    override func viewDidLoad() {
        // Load
    }
}

extension ASTInfoController: UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return planetArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "planetCell",
                                                      for: indexPath)
        cell.backgroundColor = UIColor.black
        // Configure the cell
        return cell
    }
}
