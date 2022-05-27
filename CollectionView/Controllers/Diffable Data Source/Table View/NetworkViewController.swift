import UIKit

class NetworkViewController: UIViewController {

    var tableView: UITableView!
    var dataSource: UITableViewDiffableDataSource<Section, String>!
    var wifiEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        
        configureDataSource()
        updateUI()
    }
    
    private func configureDataSource()  {
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var config = cell.defaultContentConfiguration()
            config.text = itemIdentifier
            
            if indexPath.section == 0 && indexPath.row == 0 {
                let wifiSwitch = UISwitch()
                wifiSwitch.isOn = self.wifiEnabled
                wifiSwitch.addTarget(self, action: #selector(self.toggleWifi(_:)), for: .touchUpInside)
                cell.accessoryView = wifiSwitch
            }
            else {
                cell.accessoryType = .detailDisclosureButton
                cell.accessoryView = nil
            }
            
            cell.contentConfiguration = config
            return cell
        })
        
        dataSource.defaultRowAnimation = .fade
    }

    @objc
    func toggleWifi(_ wifiSwitch: UISwitch) {
        wifiEnabled = wifiSwitch.isOn
        updateUI(wifiEnabled: wifiEnabled, animated: true)
    }
    
    private func updateUI(wifiEnabled: Bool = true, animated: Bool = true) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.first])
        snapshot.appendItems(["Wi-Fi", "home"], toSection: .first)
        
        if wifiEnabled {
            snapshot.appendSections([.second])
            snapshot.appendItems(networks1, toSection: .second)
        }
        
        dataSource.apply(snapshot, animatingDifferences: animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.refreshNetworks()
        }
    }
    
    private func refreshNetworks() {
        
        func addNetwork() {
            let index = Int.random(in: 0..<networks2.count)
            networks1.append(networks2[index])
            networks2.remove(at: index)
        }
        
        func removeNetwork() {
            let index = Int.random(in: 0..<networks1.count)
            networks2.append(networks1[index])
            networks1.remove(at: index)
        }
        
        if networks1.count < 5 {
            addNetwork()
        }
        else if networks1.count > 7 {
            removeNetwork()
        }
        else {
            Bool.random() ? addNetwork() : removeNetwork()
        }
        
        updateUI(wifiEnabled: wifiEnabled, animated: true)
    }
    
    var networks1 = [
        "orion",
        "office-1-2-3",
        "guest free",
        "chris's wireless",
        "sweat home",
        "jason's home",
        "james",
        "my office",
        "rimgate",
        "ferleaf123"
    ]
    
    var networks2: [String] = []
}
