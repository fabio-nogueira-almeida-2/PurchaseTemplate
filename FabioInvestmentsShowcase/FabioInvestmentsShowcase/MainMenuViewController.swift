//import UIKit
//
//
//class MainMenuViewController: UIViewController {
//    
//    private let tableView = UITableView(frame: .zero, style: .grouped)
//    
////    private let menuItems = [
//////        MenuItem(title: "Purchase Custody", description: "Investment custody management with filtering", flow: .custody),
//////        MenuItem(title: "Purchase Offer Detail", description: "Detailed investment product information", flow: .offerDetail),
//////        MenuItem(title: "Purchase Offers List", description: "List of available investment offers", flow: .offersList),
//////        MenuItem(title: "Orders Management", description: "Order management system", flow: .orders),
//////        MenuItem(title: "Purchase Result", description: "Investment purchase confirmation", flow: .result)
////    ]
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//    }
//    
//    private func setupUI() {
//        title = "Fabio's Investment Flows"
//        view.backgroundColor = .systemBackground
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//        
//        view.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//}
//
//extension MainMenuViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return menuItems.count
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
////        let item = menuItems[indexPath.row]
//        
////        cell.textLabel?.text = item.title
////        cell.detailTextLabel?.text = item.description
//        cell.accessoryType = .disclosureIndicator
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
////        let item = menuItems[indexPath.row]
////        navigateToFlow(item.flow)
//    }
//    
//    private func navigateToFlow(_ flow: InvestmentFlow) {
//        switch flow {
//        case .custody:
//            let coordinator = PurchaseCustodyCoordinator(navigationController: navigationController!)
//            coordinator.start()
//        case .offerDetail:
//            let coordinator = PurchaseDetailCoordinator(navigationController: navigationController!)
//            coordinator.start()
//        case .offersList:
//            let coordinator = PurchaseListCoordinator(navigationController: navigationController!)
//            coordinator.start()
//        case .orders:
//            let coordinator = OrdersCoordinator(navigationController: navigationController!)
//            coordinator.start()
//        case .result:
//            let coordinator = PurchaseResultCoordinator(navigationController: navigationController!)
//            coordinator.start()
//        }
//    }
//}
