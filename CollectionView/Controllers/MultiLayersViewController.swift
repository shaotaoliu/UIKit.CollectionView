import UIKit

class MultiLayersViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<ExpandableItem, ExpandableItem>!
    
    let items = [
        ExpandableItem(name: "Circle", image: "circle.fill", color: .systemRed, items: [
            ExpandableItem(name: "Information", image: "info.circle", color: .systemGreen, items: [
                ExpandableItem(name: "Lock", image: "lock", color: .systemOrange),
                ExpandableItem(name: "Photo", image: "phone", color: .systemOrange)
            ]),
            ExpandableItem(name: "Person", image: "person.circle", color: .systemGreen, items: [
                ExpandableItem(name: "Snowflake", image: "snowflake", color: .systemOrange),
                ExpandableItem(name: "Star", image: "star", color: .systemOrange)
            ])
        ]),
        ExpandableItem(name: "Square", image: "square.fill", color: .systemRed, items: [
            ExpandableItem(name: "Trash", image: "trash", color: .systemGreen, items: [
                ExpandableItem(name: "Mic", image: "mic", color: .systemOrange),
                ExpandableItem(name: "Play", image: "play", color: .systemOrange)
            ]),
            ExpandableItem(name: "Bookmark", image: "bookmark", color: .systemGreen, items: [
                ExpandableItem(name: "Bolt", image: "bolt", color: .systemOrange),
                ExpandableItem(name: "Multiply", image: "multiply", color: .systemOrange)
            ])
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayoutConfig()
        setupDataSource()
        setupSnapshot()
    }
    
    private func setupLayoutConfig() {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func setupDataSource() {
        
        let parent = UICollectionView.CellRegistration<UICollectionViewListCell, ExpandableItem> { cell, indexPath, item in
            var config = cell.defaultContentConfiguration()
            config.image = UIImage(systemName: item.image!)
            config.imageProperties.tintColor = item.color
            config.text = item.name
            config.textProperties.font = .boldSystemFont(ofSize: 16)
            cell.contentConfiguration = config
            
            let options = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: options)]
        }
        
        let child = UICollectionView.CellRegistration<UICollectionViewListCell, ExpandableItem> { cell, indexPath, item in
            var config = cell.defaultContentConfiguration()
            config.image = UIImage(systemName: item.image!)
            config.imageProperties.tintColor = item.color
            config.text = item.name
            cell.contentConfiguration = config
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            let registration = (item.items == nil || item.items!.isEmpty) ? child : parent
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
            return cell
        })
    }
    
    private func setupSnapshot() {
        func appendChildren(_ children: [ExpandableItem]?, to parent: ExpandableItem, snapshot: inout NSDiffableDataSourceSectionSnapshot<ExpandableItem>) {
            if let children = children, !children.isEmpty {
                snapshot.append(children, to: parent)
                snapshot.expand([parent])
                
                for child in children {
                    appendChildren(child.items, to: child, snapshot: &snapshot)
                }
            }
        }
        
        for section in items {
            var snapshot = NSDiffableDataSourceSectionSnapshot<ExpandableItem>()
            snapshot.append([section])
            appendChildren(section.items, to: section, snapshot: &snapshot)
            dataSource.apply(snapshot, to: section, animatingDifferences: false)
        }
    }
}
