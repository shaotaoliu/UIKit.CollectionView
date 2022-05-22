import UIKit

class BasicCollectionViewController: UIViewController {

    var collectionView: UICollectionView!
    let images = (1...20).map { "image\($0)" }
    let spacing: CGFloat = 2.0
    let countPerRow = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CollectionViewCell")
        
        view.addSubview(collectionView)
    }
}

extension BasicCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
}

extension BasicCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.setImage(imageName: images[indexPath.row])
        return cell
    }
}

extension BasicCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (view.bounds.width - spacing * CGFloat(countPerRow - 1)) / CGFloat(countPerRow)
        return CGSize(width: length, height: length)
    }
}

extension BasicCollectionViewController {
    
    // MARK: - add the context menu:
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let openAction = UIAction(title: "Open", image: UIImage(systemName: "link"), state: .off) { _ in
            print("Open")
        }
        
        let printAction = UIAction(title: "Print", image: UIImage(systemName: "printer"), state: .off) { _ in
            print("Print")
        }
        
        let menu = UIMenu(title: "Actions", options: .displayInline, children: [openAction, printAction])
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return menu
        }
    }
}
