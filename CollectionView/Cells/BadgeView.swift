import UIKit

class BadgeView: UICollectionReusableView {

    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    override var frame: CGRect {
        didSet {
            setBorder()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            setBorder()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    private func configure() {
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        backgroundColor = .green
        setBorder()
    }
    
    private func setBorder() {
        let radius = bounds.width / 2.0
        
        layer.cornerRadius = radius
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
    }
}
