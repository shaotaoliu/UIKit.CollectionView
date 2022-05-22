import UIKit

class ViewController: UIViewController {

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<CollectionExample, CollectionExample>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
        setupDataSource()
        setupSnapshot()
    }
    
    private func setupSubViews() {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        // config.headerMode = .firstItemInSection
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.delegate = self
        
        view.addSubview(collectionView)
    }
    
    private func setupDataSource() {
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, CollectionExample> { cell, indexPath, example in
            var config = cell.defaultContentConfiguration()
            config.text = example.title
            config.textProperties.font = .preferredFont(forTextStyle: .headline)
            cell.contentConfiguration = config
            
            let options = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: options)]
            cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, CollectionExample> { cell, indexPath, example in
            var config = cell.defaultContentConfiguration()
            config.text = example.title
            cell.contentConfiguration = config
            cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
        
        dataSource = UICollectionViewDiffableDataSource<CollectionExample, CollectionExample>(collectionView: collectionView, cellProvider: { collectionView, indexPath, example in
            if example.examples != nil {
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: example)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: example)
            }
        })
    }
    
    private func setupSnapshot() {
        func appendChildren(_ children: [CollectionExample]?, to parent: CollectionExample, snapshot: inout NSDiffableDataSourceSectionSnapshot<CollectionExample>) {
            if let children = children, !children.isEmpty {
                snapshot.append(children, to: parent)
                
                if parent.expanded {
                    snapshot.expand([parent])
                }
                
                for child in children {
                    appendChildren(child.examples, to: child, snapshot: &snapshot)
                }
            }
        }
        
        for section in collectionExamples {
            var snapshot = NSDiffableDataSourceSectionSnapshot<CollectionExample>()
            snapshot.append([section])
            appendChildren(section.examples, to: section, snapshot: &snapshot)
            dataSource.apply(snapshot, to: section, animatingDifferences: false)
        }
    }
    
//    private func setupSnapshot() {
//        for section in collectionExamples {
//            var snapshot = NSDiffableDataSourceSectionSnapshot<CollectionExample>()
//            snapshot.append([section])
//
//            if let examples = section.examples {
//                snapshot.append(examples, to: section)
//
//                if section.expanded {
//                    snapshot.expand([section])
//                }
//            }
//
//            dataSource.apply(snapshot, to: section, animatingDifferences: false)
//        }
//    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let example = self.dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let viewController = example.viewController {
            let controller = viewController.init()
            controller.title = example.title
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
