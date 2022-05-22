import UIKit

class SearchableViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayoutConfig()
        setupDataSource()
        setupSnapshot()
        
        searchBar.delegate = self
    }
    
    private func setupLayoutConfig() {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            let columns = environment.container.effectiveContentSize.width > 800 ? 3 : 2
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(35)),
                subitem: item, count: columns)
            
            group.interItemSpacing = .fixed(10)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            return section
        }
        
        collectionView.collectionViewLayout = layout
    }
    
    private func setupDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<TextCell, String> { cell, indexPath, name in
            cell.label.text = name
            cell.label.textAlignment = .left
            cell.label.font = UIFont.systemFont(ofSize: 16)
            cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
            cell.contentView.layer.borderWidth = 1
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, name in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: name)
        })
    }

    private func setupSnapshot(with filter: String? = nil) {
        
        func filterNames(names: [String], with filter: String?) -> [String] {
            guard let filter = filter, !filter.isEmpty else {
                return names
            }
            
            return names.filter {
                $0.lowercased().contains(filter.lowercased())
            }
        }
        
        let filteredNames = filterNames(names: names, with: filter)
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.first])
        snapshot.appendItems(filteredNames)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    let names = [
        "Addison", "Albany", "Alfred", "Andrew", "Angela", "Ashley",
        "Barbara", "Barney", "Barrett", "Barris", "Bruce", "Brain",
        "Carin", "Carita", "Carla", "Carlene", "Chris", "Carlo",
        "Daisy", "David", "Dallas", "Daniel", "Deborah", "Diana",
        "Francis", "Francisco", "Frank", "Funda", "Fabio", "Farah",
        "Jack", "Jackie", "Jackson", "Jason", "James", "Jordon",
        "John", "Jeffrey", "Joseph", "Jennifer", "Joshua", "Jessica",
        "Jonathan", "Justin", "Janet", "Jerry", "Jose", "Joyce",
        "Robert", "Richard", "Rebecca", "Ronald", "Ryan", "Randy",
        "Mike", "Michael", "Mary", "Mark", "Margaret", "Michelle",
        "Linda", "Lisa", "Laura", "Larry", "Lauren", "Louis",
        "Susan", "Sarah", "Sandra", "Steven", "Smith", "Sharon",
        "Scott", "Sophia", "Sara", "Sean", "Samuel", "Stephen",
        "Thomas", "Theresa", "Terry", "Teresa", "William", "Wayne"
    ]
}

extension SearchableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        setupSnapshot(with: searchText)
    }
}
