import UIKit

class CollectionImageCell: UICollectionViewCell {
    
    private var imageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    func setImage(imageName: String) {
        self.imageView.image = UIImage(named: imageName)
    }
}
