import UIKit

class RootCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    class func reuseIdentifier() -> String {
        return "RootCollectionViewCell"
    }

}
