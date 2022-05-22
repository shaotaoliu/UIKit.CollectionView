import UIKit

class SectionBackgroundViewController: UIViewController {

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    let names = ["Kevin", "Smith", "Jason", "James", "Bruce", "Lucas"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayoutConfig()
        setupDataSource()
        setupSnapshot()
    }
    
    private func setupLayoutConfig() {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(44)),
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        // Section background:
        let background = NSCollectionLayoutDecorationItem.background(elementKind: "backgroundElementKind")
        background.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        section.decorationItems = [background]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.register(SectionBackgroundView.self, forDecorationViewOfKind: "backgroundElementKind")
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
    }
    
    private func setupDataSource() {
        
        let listRegistration = UICollectionView.CellRegistration<ListCell, String> { cell, indexPath, name in
            cell.label.text = name
            
            // if it is the last row:
            let count = self.dataSource.snapshot().numberOfItems(inSection: .first)
            if count == indexPath.item + 1 {
                cell.seperator.isHidden = true
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, name in
            return collectionView.dequeueConfiguredReusableCell(using: listRegistration, for: indexPath, item: name)
        }
    }
    
    private func setupSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.first])
        snapshot.appendItems(names)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
