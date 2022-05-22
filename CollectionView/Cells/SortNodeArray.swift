import UIKit

struct SortNode: Hashable {
    let value: Int
    let color: UIColor
    
    init(value: Int, maxValue: Int) {
        self.value = value
        let hue = CGFloat(value) / CGFloat(maxValue)
        self.color = UIColor(hue: hue,saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
    
    private let id = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: SortNode, rhs: SortNode) -> Bool {
        return lhs.id == rhs.id
    }
}

class SortNodeArray {
    
    var nodes: [SortNode]
    var isSorted: Bool = false
    
    private var currentIndex = 1
    private let id = UUID()
    
    init(count: Int) {
        nodes = (0..<count).map {
            SortNode(value: $0, maxValue: count)
        }
        .shuffled()
    }
    
    func sort() {
        if isSorted {
            return
        }
        
        var index = currentIndex
        
        while index > 0 && nodes[index].value < nodes[index - 1].value {
            let temp = nodes[index]
            nodes[index] = nodes[index - 1]
            nodes[index - 1] = temp
            index -= 1
        }
        
        if currentIndex == nodes.count - 1 {
            isSorted = true
        } else {
            currentIndex += 1
        }
    }
}

extension SortNodeArray: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: SortNodeArray, rhs: SortNodeArray) -> Bool {
        return lhs.id == rhs.id
    }
}

