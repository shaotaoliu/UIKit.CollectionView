import UIKit

class SectionHeaderViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var images = (1...20).map { "image\($0)"}
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView!.register(nib, forCellWithReuseIdentifier: "CollectionViewCell")
        
        collectionView.collectionViewLayout = createLayout()
        setupDataSource()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(1/3)),
            subitems: [item])
        
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: size,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: size,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom)
        
        header.pinToVisibleBounds = true
        header.zIndex = 2
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header, footer]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func setupDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, imageName in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            cell.setImage(imageName: imageName)
            return cell
        })
        
        let header = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            let section = Section(rawValue: indexPath.section)
            var config = supplementaryView.defaultContentConfiguration()
            config.text = "Header (\(section == .first ? "First" : "Second") Section)"
            supplementaryView.contentConfiguration = config
        }
        
        let footer = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionFooter) { supplementaryView, elementKind, indexPath in
            let section = Section(rawValue: indexPath.section)
            var config = supplementaryView.defaultContentConfiguration()
            config.text = "Footer (\(section == .first ? "First" : "Second") Section)"
            supplementaryView.contentConfiguration = config
        }
        
        dataSource.supplementaryViewProvider = { supplementaryView, elementKind, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: elementKind == UICollectionView.elementKindSectionHeader ? header : footer,
                for: indexPath)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.first, .second])
        snapshot.appendItems(Array(images[0...8]), toSection: .first)
        snapshot.appendItems(Array(images[9...19]), toSection: .second)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
