import UIKit

class AdaptiveSectionViewController: UIViewController {

    static let BadgeElementKind = "BadgeElementKind"
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<MultiSection, Int>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayoutConfig()
        setupDataSource()
        setupBadges()
        setupSnapshot()
    }
    
    private func setupLayoutConfig() {
        
        func getLayoutItem(hasBadge: Bool) -> NSCollectionLayoutItem {
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1))
            
            if hasBadge {
                let badge = NSCollectionLayoutSupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(20), heightDimension: .absolute(20)),
                    elementKind: AdaptiveSectionViewController.BadgeElementKind,
                    containerAnchor: NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: 0.3, y: -0.3)))
                
                return NSCollectionLayoutItem(layoutSize: size, supplementaryItems: [badge])
            }
            
            return NSCollectionLayoutItem(layoutSize: size)
        }
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in

            let section = MultiSection(rawValue: sectionIndex)!
            var columns = section.columns()

            if layoutEnvironment.container.effectiveContentSize.width > 800 {
                columns *= 2
            }
            
            let item = getLayoutItem(hasBadge: section == .grid3)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let groupHeight = section == .list ? NSCollectionLayoutDimension.absolute(44) : NSCollectionLayoutDimension.fractionalWidth(0.2)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: groupHeight),
                subitem: item, count: columns)
            
            let layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            return layoutSection
        }
        
        collectionView.collectionViewLayout = layout
    }
    
    private func setupDataSource() {
        
        let listRegistration = UICollectionView.CellRegistration<ListCell, Int> { cell, indexPath, number in
            cell.label.text = "\(number)"
        }
        
        let cellRegistration = UICollectionView.CellRegistration<TextCell, Int> { cell, indexPath, number in
            cell.label.text = "\(number)"
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
            cell.contentView.backgroundColor = .systemBlue
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = MultiSection(rawValue: indexPath.section)! == .grid5 ? 8 : 0
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, number in
            if MultiSection(rawValue: indexPath.section)! == .list {
                return collectionView.dequeueConfiguredReusableCell(using: listRegistration, for: indexPath, item: number)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: number)
            }
        }
    }
    
    private func setupBadges() {
        let badgeRegistration = UICollectionView.SupplementaryRegistration<BadgeView>(
            elementKind: AdaptiveSectionViewController.BadgeElementKind) { supplementaryView, elementKind, indexPath in
            
                let number = self.dataSource.itemIdentifier(for: indexPath)!
                let x = Int.random(in: 0..<number)
                
                supplementaryView.label.text = "\(x)"
                supplementaryView.isHidden = x == 0
        }
        
        dataSource.supplementaryViewProvider = {
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: badgeRegistration, for: $2)
        }
    }
    
    private func setupSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<MultiSection, Int>()
        let count = 10
        
        MultiSection.allCases.forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems(Array((count * $0.rawValue + 1)...(count * $0.rawValue + count)))
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    enum MultiSection: Int, CaseIterable {
        case list
        case grid5
        case grid3
        
        func columns() -> Int {
            switch self {
            case .list:
                return 1
                
            case .grid5:
                return 5
                
            case .grid3:
                return 3
            }
        }
    }
}
