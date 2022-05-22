import UIKit

class DiffableListViewController: UIViewController {

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, ExpandableItem>!
    
    let items = [
        ExpandableItem(name: "Information", image: "info.circle", color: .systemPurple),
        ExpandableItem(name: "Photo", image: "phone.circle", color: .systemGreen),
        ExpandableItem(name: "Lock", image: "lock.circle", color: .systemBrown),
        ExpandableItem(name: "Rain", image: "cloud.rain.fill", color: .systemCyan),
        ExpandableItem(name: "Sunny", image: "sun.max.fill", color: .systemRed),
        ExpandableItem(name: "Person", image: "person.circle", color: .systemOrange),
        ExpandableItem(name: "Bell", image: "bell.fill", color: .systemMint),
        ExpandableItem(name: "Gear", image: "gear", color: .systemBlue)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayoutConfig()
        setupDataSource()
        setupSnapshot()
    }
    
    private func setupLayoutConfig() {
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
    }
    
    private func setupDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ExpandableItem> { cell, indexPath, item in
            var config = cell.defaultContentConfiguration()
            config.text = item.name
            config.image = UIImage(systemName: item.image!)
            config.imageProperties.tintColor = item.color
            cell.contentConfiguration = config
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            cell.accessories = [.disclosureIndicator()]
            return cell
        })
    }

    private func setupSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ExpandableItem>()
        snapshot.appendSections([.first])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
