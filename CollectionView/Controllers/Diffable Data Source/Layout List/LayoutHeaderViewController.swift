import UIKit

class LayoutHeaderViewController: UIViewController {

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<ExpandableItem, ExpandableItem>!
    
    let items = [
        ExpandableItem(name: "Circle", items: [
            ExpandableItem(name: "Information", image: "info.circle"),
            ExpandableItem(name: "Photo", image: "phone.circle"),
            ExpandableItem(name: "Lock", image: "lock.circle"),
            ExpandableItem(name: "Person", image: "person.circle")
        ]),
        ExpandableItem(name: "Square", items: [
            ExpandableItem(name: "Trash", image: "trash.square"),
            ExpandableItem(name: "Mic", image: "mic.square"),
            ExpandableItem(name: "Play", image: "play.square"),
            ExpandableItem(name: "Bookmark", image: "bookmark.square"),
            ExpandableItem(name: "Bolt", image: "bolt.square")
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayoutConfig()
        setupDataSource()
        setupHeaderFooter()
        setupSnapshot()
    }
    
    private func setupLayoutConfig() {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.headerMode = .supplementary
        config.footerMode = .supplementary
        
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
    }
    
    private func setupDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ExpandableItem> { cell, indexPath, item in
            var config = cell.defaultContentConfiguration()
            config.image = UIImage(systemName: item.image!)
            config.imageProperties.tintColor = .systemOrange
            config.text = item.name
            cell.contentConfiguration = config
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        })
    }

    private func setupHeaderFooter() {
        
        let header = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            var config = supplementaryView.defaultContentConfiguration()
            
            config.text = section.name
            config.textProperties.color = .systemPurple
            config.textProperties.font = .boldSystemFont(ofSize: 16)
            config.directionalLayoutMargins = .init(top: 20, leading: 0, bottom: 10, trailing: 0)
            
            supplementaryView.contentConfiguration = config
        }
        
        let header2 = UICollectionView.SupplementaryRegistration<HeaderCell>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            supplementaryView.label.text = section.name
            
            supplementaryView.action = { [weak self] in
                let count = section.items?.count
                let alert = UIAlertController(title: "Info", message: "This section has \(count ?? 0) items.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
        
        let footer = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionFooter) { supplementaryView, elementKind, indexPath in
            let section = self.items[indexPath.section]
            var config = supplementaryView.defaultContentConfiguration()
            config.text = "Count: \(section.items?.count ?? 0)"
            supplementaryView.contentConfiguration = config
        }
        
        dataSource.supplementaryViewProvider = { supplementaryView, elementKind, indexPath in
            if elementKind == UICollectionView.elementKindSectionHeader {
                if indexPath.section == 0 {
                    return self.collectionView.dequeueConfiguredReusableSupplementary(using: header, for: indexPath)
                }
                
                return self.collectionView.dequeueConfiguredReusableSupplementary(using: header2, for: indexPath)
            }
            
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: footer, for: indexPath)
        }
    }
    
    private func setupSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ExpandableItem, ExpandableItem>()
        snapshot.appendSections(items)
        
        for header in items {
            snapshot.appendItems(header.items!, toSection: header)
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
