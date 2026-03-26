import UIKit

struct PurchaseDetailDTO {
    let title: StringWithTypograph?
    let detail: StringWithTypograph?
    let productType: String?
    let sections: [Section]
    let documents: [DocumentItem]

    struct Section {
        let title: String?
        let rows: [Field]
    }

    struct Field {
        let label: StringWithTypograph?
        let value: StringWithTypograph?
    }

    struct DocumentItem {
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

final class PurchaseDetailViewController: ViewController<PurchaseDetailInteracting, UIView> {
    typealias Localizable = Strings.Purchase.Detail
    // MARK: - View
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var actionButton: Button = {
        let view = Button(style: .primary, label: Localizable.investButton) {
            self.interactor.didConfirm()
        }
        return view
    }()

    private lazy var headerView = PurchaseDetailHeaderView()

    // MARK: - Loading
    private func skeletonViews() -> [UIView] {
        var views = headerView.subviews
        views.append(tableView)
        views.append(actionButton)
        return views
    }

    // MARK: - Properties
    private var dto: PurchaseDetailDTO?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.fetchData()
    }

    // MARK: - Layout
    override func buildViewHierarchy() {
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(actionButton)
    }

    override func setupConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(tableView.snp.top)
        }
        tableView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(actionButton.snp.top)
        }
        actionButton.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.equalToSuperview().inset(Space.base04.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base04.rawValue)
            $0.bottom.equalToSuperview().inset(Space.base04.rawValue)
            $0.height.equalTo(Space.base08.rawValue)
        }
    }

    override func configureViews() {
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PurchaseDetailTableViewCell.self, forCellReuseIdentifier: PurchaseDetailTableViewCell.identifier)
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
        if !dto.documents.isEmpty {
            return defaultSections + 1
        }

        return defaultSections
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dto = dto, let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseDetailTableViewCell.identifier,
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
            title = Localizable.documents
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
        beginState()
    }

    func stopLoading() {
        endState()
    }

    func displayFeedback(feedback: InvestmentsHubFeedback) {
        if feedback == .connectionFailureError {
            display(feedback: feedback, primaryAction: { [weak self] in
                self?.interactor.fetchData()
            }) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        } else {
            display(feedback: feedback) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - StatefulTransitionViewing
extension PurchaseDetailViewController: StatefulTransitionViewing {
    func statefulViewForLoading() -> StatefulViewing {
        PurchaseDetailSkeletonView()
    }
}
