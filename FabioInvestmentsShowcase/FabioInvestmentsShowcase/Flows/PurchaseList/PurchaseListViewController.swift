import UIKit

struct PurchaseListDTO: Decodable {
    let title: StringWithTypograph?
    let detail: StringWithTypograph?
    let headerTitle: StringWithTypograph?
    let cards: [Card]
    struct Card: Decodable {
        let fields: [Field]
    }
    struct Field: Decodable {
        let label: StringWithTypograph?
        let value: StringWithTypograph?
    }
}

protocol PurchaseListDisplaying: AnyObject {
    func display(dto: PurchaseListDTO)
    func starLoading()
    func stopLoading()
    func displayFeedback(feedback: InvestmentsHubFeedback)
}

final class PurchaseListViewController: UIViewController {
    // MARK: - View
    private lazy var headerView = PurchaseListHeaderView()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - Properties
    private var dto: PurchaseListDTO?
    private let interactor: PurchaseListInteracting

    init(interactor: PurchaseListInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor.fetchData()
    }

    // MARK: - Layout
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(headerView)
        view.addSubview(tableView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PurchaseListTableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    func setup(_ dto: PurchaseListDTO) {
        self.dto = dto
        title = dto.title?.value
        headerView.setup(
            title: dto.headerTitle ?? .init(value: "", typograph: ""),
            description: dto.detail ?? .init(value: "", typograph: "")
        )
        tableView.reloadData()
    }
}

extension PurchaseListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        interactor.didSelect(index: indexPath.row)
    }
}

// MARK: - PurchaseListDisplaying
extension PurchaseListViewController: PurchaseListDisplaying {
    func display(dto: PurchaseListDTO) {
        setup(dto)
    }

    func starLoading() {
        // Show loading state
    }

    func stopLoading() {
        // Hide loading state
    }

    func displayFeedback(feedback: InvestmentsHubFeedback) {
        if feedback == .connectionFailureError {
            showConnectionError(with: feedback) { [weak self] in
                self?.interactor.fetchData()
            }
        } else {
            showGenericError(with: feedback)
        }
    }
}

// MARK: - UITableViewDataSource
extension PurchaseListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dto?.cards.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PurchaseListTableViewCell else {
            return UITableViewCell()
        }
        if let card = dto?.cards[indexPath.row] {
            cell.setup(with: card)
        }
        return cell
    }
}

// MARK: - Error Handling
extension PurchaseListViewController {
    func showConnectionError(with feedback: InvestmentsHubFeedback, retry: @escaping () -> Void) {
        let alert = UIAlertController(title: "Connection Error", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
            retry()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func showGenericError(with feedback: InvestmentsHubFeedback) {
        let alert = UIAlertController(title: "Error", message: "Something went wrong. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

