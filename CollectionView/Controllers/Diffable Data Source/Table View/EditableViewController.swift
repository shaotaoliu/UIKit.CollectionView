import UIKit

class EditableViewController: UIViewController {

    var tableView: UITableView!
    var dataSource: EditableDataSource!
    var rightBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupSubViews()
        setupDataSource()
        setupSnapshot()
    }
    
    private func setupSubViews() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditing))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc
    func toggleEditing() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        rightBarButtonItem.title = tableView.isEditing ? "Done" : "Edit"
    }
    
    private func setupDataSource() {

        dataSource = EditableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var config = cell.defaultContentConfiguration()
            config.text = itemIdentifier.name
            cell.contentConfiguration = config
            return cell
        })
    }
    
    func setupSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<EditableSection, EditableItem>()
        
        for section in dataSource.items {
            snapshot.appendSections([section])
            snapshot.appendItems(section.items)
        }

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

struct EditableSection: Hashable {
    let header: String
    let footer: String
    let items: [EditableItem]
}

struct EditableItem: Hashable {
    let name: String
}

class EditableDataSource: UITableViewDiffableDataSource<EditableSection, EditableItem> {
    
    let items = [
        EditableSection(header: "Section 1", footer: "This is section 1", items: [
            EditableItem(name: "Apple"),
            EditableItem(name: "Peach"),
            EditableItem(name: "Pear"),
            EditableItem(name: "Watermelon"),
            EditableItem(name: "Strawberry")
        ]),
        EditableSection(header: "Section 2", footer: "This is section 2", items: [
            EditableItem(name: "Noodle"),
            EditableItem(name: "Pizza"),
            EditableItem(name: "Mantou"),
            EditableItem(name: "Doufu"),
            EditableItem(name: "Meat")
        ])
    ]
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let editableSection = items[section]
        return editableSection.header
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let editableSection = items[section]
        return editableSection.footer
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath == destinationIndexPath {
            return
        }
        
        guard let sourceItem = itemIdentifier(for: sourceIndexPath) else {
            return
        }
        
        var snapshot = self.snapshot()
        
        if let destinationItem = itemIdentifier(for: destinationIndexPath) {
            // move in the same section:
            if let sourceIndex = snapshot.indexOfItem(sourceItem),
               let destinationIndex = snapshot.indexOfItem(destinationItem) {
                
                let sourceSection = snapshot.sectionIdentifier(containingItem: sourceItem)
                let destinationSection = snapshot.sectionIdentifier(containingItem: destinationItem)
                
                snapshot.deleteItems([sourceItem])
                
                if destinationIndex > sourceIndex && sourceSection == destinationSection {
                    snapshot.insertItems([sourceItem], afterItem: destinationItem)
                } else {
                    snapshot.insertItems([sourceItem], beforeItem: destinationItem)
                }
            }
        }
        else {
            // move to the end of a different section:
            let destinationSection = snapshot.sectionIdentifiers[destinationIndexPath.section]
            snapshot.deleteItems([sourceItem])
            snapshot.appendItems([sourceItem], toSection: destinationSection)
        }
        
        self.apply(snapshot, animatingDifferences: false)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = itemIdentifier(for: indexPath) {
                var snapshot = self.snapshot()
                snapshot.deleteItems([item])
                apply(snapshot)
            }
        }
    }
}
