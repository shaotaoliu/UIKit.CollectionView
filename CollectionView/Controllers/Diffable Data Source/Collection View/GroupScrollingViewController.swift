import UIKit

class GroupScrollingViewController: UIViewController {

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<ScrollingSection, Int>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupDataSource()
        setupHeaders()
    }
    
    private func setupLayout() {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, environment in
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3),
                                                   heightDimension: .fractionalWidth(1/2)),
                subitems: [item])
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(30)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            
            // set the section scorlling behavior:
            if let scrollingSection = ScrollingSection(rawValue: sectionIndex) {
                section.orthogonalScrollingBehavior = scrollingSection.scrollBehavior
            }
            
            return section
        }, configuration: config)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
        
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView!.register(nib, forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    func setupDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, number in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            let num = number % 10 + 1
            cell.setImage(imageName: "image\(num)")
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<ScrollingSection, Int>()
        var start = 0
        
        ScrollingSection.allCases.forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems(Array(start...(start + 9)))
            start += 10
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func setupHeaders() {
        
        let header = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            var config = supplementaryView.defaultContentConfiguration()
            
            if let section = ScrollingSection(rawValue: indexPath.section),
               let text = String(describing: section).split(separator: .init(".")).last {
                config.text = String(".\(text)")
            }
            
            supplementaryView.contentConfiguration = config
        }
        
        dataSource.supplementaryViewProvider = { supplementaryView, elementKind, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: header, for: indexPath)
        }
    }
    
    enum ScrollingSection: Int, CaseIterable {
        case continuous
        case continuousGroupLeadingBoundary
        case paging
        case groupPaging
        case groupPagingCentered
        case none
        
        var scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior {
            switch self {
            case .continuous:
                return .continuous
            case .continuousGroupLeadingBoundary:
                return .continuousGroupLeadingBoundary
            case .paging:
                return .paging
            case .groupPaging:
                return .groupPaging
            case .groupPagingCentered:
                return .groupPagingCentered
            case .none:
                return .none
            }
        }
    }
}
