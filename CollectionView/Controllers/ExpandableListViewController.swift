import UIKit

class ExpandableListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
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
            ExpandableItem(name: "Bookmark", image: "bookmark.square")
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayoutConfig()
        setupDataSource()
        setupSnapshot()
        updateBarButtonItem()
    }
    
    // MARK: - UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    
    private var appearance = UICollectionLayoutListConfiguration.Appearance.plain
    
    private func updateBarButtonItem() {
        var title = String(describing: appearance)
        title = title.first!.uppercased() + title.dropFirst()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: title,
            style: .plain,
            target: self,
            action: #selector(refreshListAppearance))
    }
    
    @objc
    private func refreshListAppearance() {
        switch appearance {
        case .plain:
            appearance = .sidebarPlain
        case .sidebarPlain:
            appearance = .sidebar
        case .sidebar:
            appearance = .grouped
        case .grouped:
            appearance = .insetGrouped
        case .insetGrouped:
            appearance = .plain
        default:
            break
        }
        
        let selectedIndex = collectionView.indexPathsForSelectedItems?.first
        
        setupLayoutConfig()
        dataSource.apply(dataSource.snapshot(), animatingDifferences: false)
        
        if let index = selectedIndex {
            collectionView.selectItem(at: index, animated: false, scrollPosition: [])
        }
        
        updateBarButtonItem()
    }
    
    private func setupLayoutConfig() {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: self.appearance)
        layoutConfig.headerMode = .firstItemInSection
        
        layoutConfig.leadingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            guard let self = self, let item = self.dataSource.itemIdentifier(for: indexPath) else {
                return nil
            }
            return self.getLeadingSwipeConfiguration(item: item)
        }
        
        layoutConfig.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            guard let self = self, let item = self.dataSource.itemIdentifier(for: indexPath) else {
                return nil
            }
            return self.getTrailingSwipeConfiguration(item: item)
        }
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
    }
    
    private func getLeadingSwipeConfiguration(item: ExpandableItem) -> UISwipeActionsConfiguration? {

        // only change the row with "heart"
        if item.name.count < 7 || item.name.count > 10 {
            return nil
        }
        
        let heart = UIContextualAction(style: .normal, title: "Heart") { action, view, completion in
            if let index = self.dataSource.indexPath(for: item),
               let cell = self.collectionView.cellForItem(at: index) as? UICollectionViewListCell {
                
                if cell.accessories.count > 0 {
                    cell.accessories = []
                }
                else {
                    let config = UICellAccessory.CustomViewConfiguration(
                        customView: UIImageView(image: UIImage(systemName: "heart.fill")),
                        placement: .trailing(displayed: .always),
                        tintColor: .systemRed)
                    
                    cell.accessories = [.customView(configuration: config)]
                }
            }
            
            completion(true)
        }
    
        
        heart.backgroundColor = .systemGreen
        heart.image = UIImage(systemName: "heart")

        return UISwipeActionsConfiguration(actions: [heart])
    }
    
    private func getTrailingSwipeConfiguration(item: ExpandableItem) -> UISwipeActionsConfiguration {

        let move = UIContextualAction(style: .normal, title: "Move") { action, view, completion in
            print("Move \(item.name)")
            completion(true)
        }
        
        let delete = UIContextualAction(style: .destructive, title: "Trash") { action, view, completion in
            print("Delete \(item.name)")
            completion(true)
        }
        
        move.backgroundColor = .systemBlue
        move.image = UIImage(systemName: "arrow.up.arrow.down.circle")
        
        delete.backgroundColor = .systemRed
        delete.image = UIImage(systemName: "trash")
        
        let config = UISwipeActionsConfiguration(actions: [move, delete])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
    
    private func setupDataSource() {
        
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ExpandableItem> { cell, indexPath, item in
            var config = cell.defaultContentConfiguration()
            config.text = item.name
            cell.contentConfiguration = config
            
            // Add an expandable arrow to right of the header
            cell.accessories = [.outlineDisclosure()]
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ExpandableItem> { cell, indexPath, item in
            var config = cell.defaultContentConfiguration()
            config.image = UIImage(systemName: item.image!)
            config.text = item.name
            cell.contentConfiguration = config
            
            if item.name.count > 10 {
                cell.accessories = []
            }
            else if item.name.count > 6 {
                let config = UICellAccessory.CustomViewConfiguration(
                    customView: UIImageView(image: UIImage(systemName: "heart.fill")),
                    placement: .trailing(displayed: .always),
                    tintColor: .systemRed)
                
                cell.accessories = [.customView(configuration: config)]
            }
            else if item.name.count > 5 {
                let star = UIImageView(image: UIImage(systemName: "star.fill"))
                let starAccessory = UICellAccessory.customView(configuration: .init(customView: star, placement: .trailing()))
                cell.accessories = [.disclosureIndicator()]
                cell.accessories.append(starAccessory)
            }
            else {
                cell.accessories = [.disclosureIndicator()]
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            let registration = item.items == nil ? cellRegistration : headerRegistration
            return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
        })
    }

    private func setupSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ExpandableItem, ExpandableItem>()
        snapshot.appendSections(items)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        for header in items {
            var section = NSDiffableDataSourceSectionSnapshot<ExpandableItem>()
            section.append([header])
            section.append(header.items!, to: header)
            section.expand([header])
            dataSource.apply(section, to: header, animatingDifferences: false)
        }
    }
}

struct ExpandableItem: Hashable {
    let name: String
    let image: String?
    let color: UIColor?
    let items: [ExpandableItem]?
    
    init(name: String, image: String? = nil, color: UIColor? = .systemBlue, items: [ExpandableItem]? = nil) {
        self.name = name
        self.image = image
        self.color = color
        self.items = items
    }
}
