import UIKit

class ReorderingListViewController: UIViewController {

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<ReorderingSection, ReorderingItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMenu()
        setupLayoutConfig()
        setupDataSource()
        setupSnapshot()
        setupReordering()
    }
    
    private func setupMenu() {
        let reloadAction = UIAction(title: "Reload", image: UIImage(systemName: "arrow.counterclockwise")) { _ in
            
        }
        
        let helloAction = UIAction(title: "Hello", image: UIImage(systemName: "h.circle")) { _ in
            
        }
        
        let worldAction = UIAction(title: "World", image: UIImage(systemName: "network")) { _ in
            
        }
        
        let menu = UIMenu(title: "", children: [
            reloadAction,
            UIMenu(title: "", options: .displayInline, children: [helloAction, worldAction])
        ])
        
        helloAction.state = .on
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), menu: menu)
    }
    
    private func setupLayoutConfig() {
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
    }
    
    private func setupDataSource() {

        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ReorderingItem> { cell, indexPath, item in
            
            // use the value cell:
            var config = UIListContentConfiguration.valueCell()
            config.text = item.emoji
            config.secondaryText = item.name
            cell.contentConfiguration = config
            
            // display the reordering symbol:
            cell.accessories = [.disclosureIndicator(), .reorder(displayed: .always)]
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        })
    }

    private func setupReordering() {
        dataSource.reorderingHandlers.canReorderItem = { item in
            return true
        }
        
        dataSource.reorderingHandlers.didReorder = { [weak self] transaction in
            guard let self = self else {
                return
            }
            
            for st in transaction.sectionTransactions {
                let identifier = st.sectionIdentifier
                if let index = self.sections.firstIndex(where: { $0.name == identifier.name }) {
                    self.sections[index].items = st.finalSnapshot.items
                }
            }
            
//            // the second approach:
//            for st in transaction.sectionTransactions {
//                let identifier = st.sectionIdentifier
//                if let index = self.sections.firstIndex(where: { $0.name == identifier.name }),
//                   let updateItems = self.sections[index].items.applying(st.difference) {
//                    self.sections[index].items = updateItems
//                }
//            }
            
        }
    }
    
    private func setupSnapshot() {
        for section in sections {
            var snapshot = NSDiffableDataSourceSectionSnapshot<ReorderingItem>()
            snapshot.append(section.items)
            dataSource.apply(snapshot, to: section, animatingDifferences: false)
        }
    }

    struct ReorderingItem: Hashable {
        let name: String
        let emoji: String
    }
    
    struct ReorderingSection: Hashable {
        let name: String
        var items: [ReorderingItem]
    }
    
    var sections = [
        ReorderingSection(name: "Animals", items: [
            ReorderingItem(name: "Monkey", emoji: "🐵"),
            ReorderingItem(name: "Dog", emoji: "🐶"),
            ReorderingItem(name: "Bear", emoji: "🐻"),
            ReorderingItem(name: "Frog", emoji: "🐸"),
            ReorderingItem(name: "Tiger", emoji: "🐯")
        ]),
        ReorderingSection(name: "Foods", items: [
            ReorderingItem(name: "Apple", emoji: "🍎"),
            ReorderingItem(name: "Peach", emoji: "🍑"),
            ReorderingItem(name: "Grape", emoji: "🍇"),
            ReorderingItem(name: "Watermelon", emoji: "🍉")
        ]),
        ReorderingSection(name: "Flags", items: [
            ReorderingItem(name: "Canada", emoji: "🇨🇦"),
            ReorderingItem(name: "Germany", emoji: "🇧🇪"),
            ReorderingItem(name: "United States", emoji: "🇺🇸")
        ])
    ]
}
