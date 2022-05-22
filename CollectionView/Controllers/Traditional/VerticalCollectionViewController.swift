import UIKit

class VerticalCollectionViewController: UIViewController {

    var collectionView: UICollectionView!
    let images = (1...15).map { "image\($0)" }
    let spacing: CGFloat = 2.0
    let countPerColumn = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        view.backgroundColor = .systemBackground
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(
            frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 260),
            collectionViewLayout: layout)
        
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CollectionViewCell")
        
        collectionView.center = view.center
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
    }
}

extension VerticalCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
}

extension VerticalCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.setImage(imageName: images[indexPath.row])
        return cell
    }
}

extension VerticalCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (collectionView.frame.height - spacing * CGFloat(countPerColumn - 1)) / CGFloat(countPerColumn)
        return CGSize(width: length, height: length)
    }
}
