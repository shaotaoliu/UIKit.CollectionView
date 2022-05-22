import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    func setImage(imageName: String) {
        self.imageView.image = UIImage(named: imageName)
    }
}
