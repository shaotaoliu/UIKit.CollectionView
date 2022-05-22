import UIKit

class SortableViewController: UIViewController {

    static let NodeSize = CGSize(width: 15, height: 30)
    var collectionView: UICollectionView!
    var rightBarButtonItem: UIBarButtonItem!
    var dataSource: UICollectionViewDiffableDataSource<SortNodeArray, SortNode>!
    var isSorting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupDataSource()
        setupSnapshot()
        
        rightBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(toggleSort))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func setupCollectionView() {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            let contentSize = environment.container.effectiveContentSize
            let columns = Int(contentSize.width / SortableViewController.NodeSize.width)
            let height = SortableViewController.NodeSize.height
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(height)),
                subitem: item, count: columns)
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(collectionView)
    }

    @objc
    func toggleSort() {
        isSorting.toggle()
        
        if isSorting {
            sort()
        }
        
        rightBarButtonItem.title = isSorting ? "Stop" : "Sort"
    }
    
    private func sort(mode: Int = 1) {
        if !isSorting {
            return
        }
        
        var snapshot = dataSource.snapshot()
        var needSort = false
        
        for section in snapshot.sectionIdentifiers {
            if !section.isSorted {
                section.sort()
                
                let nodes = section.nodes
                snapshot.deleteItems(nodes)
                snapshot.appendItems(nodes, toSection: section)
                
                needSort = true
                
                if mode == 2 {
                    break
                }
            }
        }
        
        if needSort {
            dataSource.apply(snapshot)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(needSort ? (mode == 2 ? 20 : 125) : 1000)) {
            if !needSort {
                self.setupSnapshot()
            }
            
            self.sort(mode: mode)
        }
    }
    
    private func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, SortNode> { cell, indexPath, node in
            cell.backgroundColor = node.color
        }
        
        dataSource = UICollectionViewDiffableDataSource<SortNodeArray, SortNode>(collectionView: collectionView) { collectionView, indexPath, node in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: node)
        }
    }
    
    private func setupSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SortNodeArray, SortNode>()
        let rows = Int(collectionView.bounds.height / SortableViewController.NodeSize.height)
        let columns = Int(collectionView.bounds.width / SortableViewController.NodeSize.width)
        
        for _ in 0..<rows {
            let section = SortNodeArray(count: columns)
            snapshot.appendSections([section])
            snapshot.appendItems(section.nodes)
        }
        
        dataSource.apply(snapshot)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if dataSource != nil {
            setupSnapshot()
        }
    }
}
