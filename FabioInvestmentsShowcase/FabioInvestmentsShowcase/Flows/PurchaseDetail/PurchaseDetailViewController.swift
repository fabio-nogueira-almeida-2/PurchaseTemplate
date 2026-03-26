import UIKit
//import SnapKit

struct PurchaseDetailDTO: Decodable {
    let title: StringWithTypograph?
    let detail: StringWithTypograph?
    let productType: String?
    let sections: [Section]
    let documents: [DocumentItem]

    struct Section: Decodable {
        let title: String?
        let rows: [Field]
    }

    struct Field: Decodable {
        let label: StringWithTypograph?
        let value: StringWithTypograph?
    }

    struct DocumentItem: Decodable {
        let imageIcon: String
        let name: String
        let url: String
    }
}

protocol PurchaseDetailDisplaying: AnyObject {
    func display(dto: PurchaseDetailDTO)
    func startLoading()
    func stopLoading()
    func displayFeedback(feedback: InvestmentsHubFeedback)
}

final class PurchaseDetailViewController: UIViewController {
    typealias Localizable = Strings.Purchase.Detail
    
    // MARK: - View
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Invest", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapInvestButton), for: .touchUpInside)
        return button
    }()

    private lazy var headerView = PurchaseDetailHeaderView()

    // MARK: - Properties
    private var dto: PurchaseDetailDTO?
    private let interactor: PurchaseDetailInteracting

    init(interactor: PurchaseDetailInteracting) {
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
        view.addSubview(actionButton)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 120),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: actionButton.topAnchor),
            
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PurchaseDetailTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    @objc private func didTapInvestButton() {
        interactor.didConfirm()
    }

    // MARK: - Private
    func setup(dto: PurchaseDetailDTO) {
        self.dto = dto
        title = dto.productType
        headerView.setup(
            title: dto.title ?? .init(value: "", typograph: ""),
            detail: dto.detail ?? .init(value: "", typograph: "")
        )
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension PurchaseDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dto = dto else { return 0 }
        if section < dto.sections.count {
            return dto.sections[section].rows.count
        }

        return dto.documents.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let dto = dto else { return 0 }
        var defaultSections = dto.sections.count
        if dto.documents.isNotEmpty {
            return defaultSections + 1
        }

        return defaultSections
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dto = dto, let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                       for: indexPath) as? PurchaseDetailTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.section < dto.sections.count {
            let section = dto.sections[indexPath.section]
            cell.setup(with: section.rows[indexPath.row])
        } else {
            let document = dto.documents[indexPath.row]
            cell.setup(with: document)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PurchaseDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title = ""
        if section < (dto?.sections.count ?? 0) {
            title = dto?.sections[section].title ?? ""
        } else {
            title = "Documents"
        }
        let view = PurchaseDetailHeaderSectionView()
        view.setup(title: title)
        return view
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dto = dto, indexPath.section >= dto.sections.count, indexPath.row < dto.documents.count else { return }
        interactor.openDocument(urlString: dto.documents[indexPath.row].url)
    }
}

// MARK: - PurchaseDetailDisplaying
extension PurchaseDetailViewController: PurchaseDetailDisplaying {
    func display(dto: PurchaseDetailDTO) {
        setup(dto: dto)
    }

    func startLoading() {
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

// MARK: - Error Handling
extension PurchaseDetailViewController {
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

