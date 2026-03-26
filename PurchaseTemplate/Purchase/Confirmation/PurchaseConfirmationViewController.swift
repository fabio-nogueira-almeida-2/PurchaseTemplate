import Apollo
import UI

struct PurchaseConfirmationDTO {
    let title: StringWithTypograph?
    let button: String?
    let fields: [Field]

    struct Field {
        let label: StringWithTypograph?
        let value: StringWithTypograph?
    }
}

protocol PurchaseConfirmationDisplaying: AnyObject {
    func display(dto: PurchaseConfirmationDTO)
    func startLoading(viewModel: InvestmentsLoadingViewModel)
    func stopLoading()
    func displayFeedback(feedback: InvestmentsHubFeedback)
}

final class PurchaseConfirmationViewController: ViewController<PurchaseConfirmationInteracting, UIView>, InvestmentsLoadingViewProtocol {
    private lazy var closeButton = UIBarButtonBuilder.close { [weak self] in
        self?.dismiss(animated: true)
    }

    // MARK: - View
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        return tableView
    }()

    private lazy var actionButton: Button = {
        let view = Button(style: .primary, label: "") {
            self.interactor.didConfirm()
        }
        return view
    }()

    private lazy var headerView = PurchaseDetailHeaderView()
    internal lazy var loadingView = InvestmentsLoadingView()

    // MARK: - Properties
    private var dto: PurchaseConfirmationDTO?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(Space.base04.rawValue)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(tableView.snp.top)
        }
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(actionButton.snp.top)
        }
        actionButton.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(Space.base04.rawValue)
            $0.bottom.equalToSuperview().inset(Space.base04.rawValue)
            $0.height.equalTo(Space.base08.rawValue)
        }
    }

    override func configureViews() {
        navigationItem.rightBarButtonItems = [closeButton.build()]
        view.background(color: .white)
        tableView.dataSource = self
        tableView.register(PurchaseDetailTableViewCell.self, forCellReuseIdentifier: PurchaseDetailTableViewCell.identifier)
    }

    // MARK: - Private
    func setup(dto: PurchaseConfirmationDTO) {
        self.dto = dto
        headerView.setup(title: dto.title ?? .init(value: "", typograph: ""), detail: .init(value: "", typograph: ""))
        actionButton.text(dto.button ?? "")
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension PurchaseConfirmationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dto?.fields.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseDetailTableViewCell.identifier,
                                                       for: indexPath) as? PurchaseDetailTableViewCell else {
            return UITableViewCell()
        }
        let fields = dto?.fields[indexPath.row]
        cell.setup(with: .init(label: fields?.label, value: fields?.value))
        return cell
    }
}

// MARK: - RoyaltyConfirmationDisplaying
extension PurchaseConfirmationViewController: PurchaseConfirmationDisplaying {
    func display(dto: PurchaseConfirmationDTO) {
        setup(dto: dto)
    }

    func startLoading(viewModel: InvestmentsLoadingViewModel) {
        loadingView.set(viewModel: viewModel)
        navigationController?.setNavigationBarHidden(true, animated: false)
        startLoadingView()
    }

    func stopLoading() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        stopLoadingView()
    }

    func displayFeedback(feedback: InvestmentsHubFeedback) {
        if feedback == .connectionFailureError {
            showConnectionError(with: feedback) {[weak self] in
                self?.interactor.fetchData()
            }
        } else {
            showGenericError(with: feedback)
        }
    }
}
