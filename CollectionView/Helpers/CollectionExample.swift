import UIKit

let collectionExamples = [
    CollectionExample(title: "Traditional Collectin View", expanded: true, examples: [
        CollectionExample(title: "Context Menu", viewController: BasicCollectionViewController.self),
        CollectionExample(title: "Movable View", viewController: MoveCollectionViewController.self),
        CollectionExample(title: "Vertical View", viewController: VerticalCollectionViewController.self)
    ]),
    CollectionExample(title: "Compositional Layout", expanded: true, examples: [
        CollectionExample(title: "Horizonal Vertical", viewController: CompositionCollectionViewController.self),
        CollectionExample(title: "Vertical", viewController: Composition2CollectionViewController.self),
        CollectionExample(title: "Horizonal", viewController: Composition3CollectionViewController.self)
    ]),
    CollectionExample(title: "Diffable Data Source", expanded: false, examples: [
        CollectionExample(title: "Collection View", expanded: true, examples: [
            CollectionExample(title: "Diffable Data Source", viewController: DiffableCollectionViewController.self),
            CollectionExample(title: "Adative Section", viewController: AdaptiveSectionViewController.self),
            CollectionExample(title: "Section Header & Footer", viewController: SectionHeaderViewController.self),
            CollectionExample(title: "Section Background", viewController: SectionBackgroundViewController.self),
            CollectionExample(title: "Group Scrolling", viewController: GroupScrollingViewController.self),
            CollectionExample(title: "Searchable View", viewController: SearchableViewController.self),
            CollectionExample(title: "Sortable View", viewController: SortableViewController.self)
        ]),
        CollectionExample(title: "Layout List", expanded: false, examples: [
            CollectionExample(title: "Layout List", viewController: DiffableListViewController.self),
            CollectionExample(title: "Expandable List", viewController: ExpandableListViewController.self),
            CollectionExample(title: "Layout Header & Footer", viewController: LayoutHeaderViewController.self),
            CollectionExample(title: "Multi-Layer List", viewController: MultiLayersViewController.self),
            CollectionExample(title: "Reordering List", viewController: ReorderingListViewController.self)
        ]),
        CollectionExample(title: "Table View", expanded: false, examples: [
            CollectionExample(title: "Editable View", viewController: EditableViewController.self),
            CollectionExample(title: "Available Networks", viewController: NetworkViewController.self)
        ])
    ])
]

struct CollectionExample: Hashable {

    let title: String
    let expanded: Bool
    let examples: [CollectionExample]?
    let viewController: UIViewController.Type?
    
    init(title: String, expanded: Bool = false, examples: [CollectionExample]? = nil, viewController: UIViewController.Type? = nil) {
        self.title = title
        self.expanded = expanded
        self.examples = examples
        self.viewController = viewController
    }
    
    let id = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CollectionExample, rhs: CollectionExample) -> Bool {
        return lhs.id == rhs.id
    }
}
