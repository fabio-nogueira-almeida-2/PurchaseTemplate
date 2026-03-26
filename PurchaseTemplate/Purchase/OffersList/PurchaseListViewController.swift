import Apollo
import SnapKit
import UI
import UIKitUtilities

struct PurchaseListDTO {
    let title: StringWithTypograph?
    let detail: StringWithTypograph?
    let headerTitle: StringWithTypograph?
    let cards: [Card]
    struct Card {
        let fields: [Field]
    }
    struct Field {
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

final class PurchaseListViewController: ViewController<PurchaseListInteracting, UIView> {
    // MARK: - View
    private lazy var headerView = PurchaseListHeaderView()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - Properties
    private lazy var tableViewDataSource: TableViewDataSource<Int, PurchaseListDTO.Card> = {
        let dataSource = TableViewDataSource<Int, PurchaseListDTO.Card>(view: tableView)
        dataSource.add(section: 0)
        dataSource.itemProvider = { table, indexPath, model -> UITableViewCell? in
            self.setupItemProvider(from: table, on: indexPath, with: model)
        }
        return dataSource
    }()

    // MARK: - Loading
    private func skeletonViews() -> [UIView] {
        var views = headerView.subviews
        views.append(tableView)
        return views
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.fetchData()
    }

    // MARK: - Layout
    override func buildViewHierarchy() {
        view.addSubview(headerView)
        view.addSubview(tableView)
    }

    override func setupConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Space.base03.rawValue)
        }
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(headerView.snp.bottom)
        }
    }

    override func configureViews() {
        tableView.delegate = self
        tableView.dataSource = tableViewDataSource
        tableView.register(PurchaseListTableViewCell.self, forCellReuseIdentifier: PurchaseListTableViewCell.identifier)
    }

    // MARK: - Private
    private func setupItemProvider(
        from tableView: UITableView,
        on indexPath: IndexPath,
        with items: PurchaseListDTO.Card
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseListTableViewCell.identifier, for: indexPath) as? PurchaseListTableViewCell else {
            return UITableViewCell()
        }
        cell.setup(with: items)
        return cell
    }

    func setup(_ dto: PurchaseListDTO) {
        title = dto.title?.value
        headerView.setup(
            title: dto.headerTitle ?? .init(value: "", typograph: ""),
            description: dto.detail ?? .init(value: "", typograph: "")
        )
        tableViewDataSource.update(items: dto.cards, from: 0)
        tableView.reloadData()
    }
}

extension PurchaseListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor.didSelect(index: indexPath.row)
    }
}

// MARK: - PurchaseListDisplaying
extension PurchaseListViewController: PurchaseListDisplaying {
    func display(dto: PurchaseListDTO) {
        setup(dto)
    }

    func starLoading() {
        beginState()
    }

    func stopLoading() {
        endState()
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

// MARK: - StatefulTransitionViewing
extension PurchaseListViewController: StatefulTransitionViewing {
    func statefulViewForLoading() -> StatefulViewing {
        PurchaseListSkeletonView()
    }
}
