import UIKit

final class OrdersViewController: UIViewController {
    
    private let tableView = UITableView()
    private let orders = [
        OrderModel(id: "1", product: "Tesouro Selic 2029", amount: "R$ 1.000,00", status: "Completed", date: "01/01/2024"),
        OrderModel(id: "2", product: "CDB Banco XYZ", amount: "R$ 2.000,00", status: "Pending", date: "15/01/2024"),
        OrderModel(id: "3", product: "Fund of Funds", amount: "R$ 500,00", status: "Processing", date: "20/01/2024")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Orders"
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension OrdersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OrderTableViewCell
        cell.configure(with: orders[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let order = orders[indexPath.row]
        let alert = UIAlertController(title: "Order Detail", message: "Order ID: \(order.id)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

struct OrderModel {
    let id: String
    let product: String
    let amount: String
    let status: String
    let date: String
}
