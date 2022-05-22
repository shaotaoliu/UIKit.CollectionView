import UIKit

class ListCell: UICollectionViewCell {

    static let identifier = "ListCell"
    
    let label = UILabel()
    let accessory = UIImageView()
    let seperator = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    private func configure() {
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        accessory.image = UIImage(systemName: effectiveUserInterfaceLayoutDirection == .rightToLeft ? "chevron.left" : "chevron.right")
        accessory.tintColor = UIColor.lightGray.withAlphaComponent(0.7)
        accessory.translatesAutoresizingMaskIntoConstraints = false

        seperator.backgroundColor = .lightGray
        seperator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(label)
        contentView.addSubview(accessory)
        contentView.addSubview(seperator)

        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        let inset = CGFloat(10)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: accessory.trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            
            accessory.widthAnchor.constraint(equalToConstant: 13),
            accessory.heightAnchor.constraint(equalToConstant: 20),
            accessory.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            accessory.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            
            seperator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            seperator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            seperator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            seperator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
