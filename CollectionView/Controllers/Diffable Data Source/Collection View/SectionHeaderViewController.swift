import UIKit

class SectionHeaderViewController: UIViewController {

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = createLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
        
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
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Int> { cell, indexPath, number in
            let hue = CGFloat(number) / CGFloat(20)
            cell.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, number in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: number)
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
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.first, .second])
        snapshot.appendItems(Array(0...8), toSection: .first)
        snapshot.appendItems(Array(9...19), toSection: .second)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
