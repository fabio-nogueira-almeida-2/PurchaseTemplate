import Apollo
import SkeletonView
import UI

protocol PurchaseCustodyViewDelegate: AnyObject {
    func investAction()
    func didSelect(index: Int)
    func didSelect(type: PurchaseCustodyView.FilterType)
}

final class PurchaseCustodyView: UIView, ViewConfiguration {
    typealias Localizable = Strings.Purchase.Custody

    enum FilterType {
        case order
        case custody
        case all
    }

    weak var delegate: PurchaseCustodyViewDelegate?
    private var filterSelected: FilterType = .order

    // MARK: - View
    private lazy var headerView = PurchaseCustodyHeaderView()

    private lazy var chipsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = Space.base02.rawValue
        view.distribution = .fillProportionally
        return view
    }()

    private lazy var chipsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private lazy var ordersChips: Chips = {
        Chips(isToogle: true)
            .selected(true)
            .text(Localizable.activeChips)
            .action { _ in
                self.uncheckedChips()
                self.ordersChips.selected(true)
                self.filterDidSelect(.order)
            }
    }()

    private lazy var custodyChips: Chips = {
        Chips(isToogle: true)
            .text(Localizable.processingChips)
            .action { _ in
                self.uncheckedChips()
                self.custodyChips.selected(true)
                self.filterDidSelect(.custody)
            }
    }()

    private lazy var allChips: Chips = {
        Chips(isToogle: true)
            .text(Localizable.allChips)
            .action { _ in
                self.uncheckedChips()
                self.allChips.selected(true)
                self.filterDidSelect(.all)
            }
    }()

    private lazy var orderTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var custodyTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var footer: UIView = {
        let view = UIView()
        view.background(color: .background00)
        return view
    }()

    private lazy var investButton = Button(style: .primary, label: Localizable.investButton) {[weak self] in
        self?.delegate?.investAction()
    }

    // MARK: - Properties
    private lazy var orderTableViewDataSource: TableViewDataSource<Int, PurchaseCustodyDTO.Card> = {
        let dataSource = TableViewDataSource<Int, PurchaseCustodyDTO.Card>(view: orderTableView)
        dataSource.add(section: 0)
        dataSource.itemProvider = { table, indexPath, model -> UITableViewCell? in
            self.setupOrderItemProvider(from: table, on: indexPath, with: model)
        }
        return dataSource
    }()

    private lazy var custodyTableViewDataSource: TableViewDataSource<Int, PurchaseCustodyDTO.Card> = {
        let dataSource = TableViewDataSource<Int, PurchaseCustodyDTO.Card>(view: custodyTableView)
        dataSource.add(section: 0)
        dataSource.itemProvider = { table, indexPath, model -> UITableViewCell? in
            self.setupCustodyItemProvider(from: table, on: indexPath, with: model)
        }
        return dataSource
    }()

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - ViewConfiguration
    func buildViewHierarchy() {
        addSubview(headerView)
        addSubview(chipsScrollView)
        addSubview(orderTableView)
        addSubview(custodyTableView)
        addSubview(footer)
        footer.addSubview(investButton)
        chipsScrollView.addSubview(chipsStackView)
        chipsStackView.addArrangedSubview(ordersChips)
        chipsStackView.addArrangedSubview(custodyChips)
        chipsStackView.addArrangedSubview(allChips)
    }

    func setupConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        chipsScrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).inset(Space.base03.rawValue.reverseSign)
            $0.trailing.leading.equalToSuperview().inset(Space.base04.rawValue)
            $0.bottom.equalTo(orderTableView.snp.top)
        }
        chipsStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        orderTableView.snp.makeConstraints {
            $0.top.equalTo(chipsStackView.snp.bottom).inset(Space.base02.rawValue.reverseSign)
            $0.trailing.leading.equalToSuperview().inset(Space.base04.rawValue)
            $0.bottom.equalTo(footer.snp.top).inset(Space.base04.rawValue)
        }
        custodyTableView.snp.makeConstraints {
            $0.edges.equalTo(orderTableView)
        }
        footer.snp.makeConstraints {
            $0.bottom.trailing.leading.equalToSuperview()
            $0.height.equalTo(Space.base12.rawValue)
        }
        investButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Space.base03.rawValue)
            $0.leading.trailing.bottom.equalToSuperview().inset(Space.base04.rawValue)
        }
    }

    func configureViews() {
        background(color: .white)
        configureOrderTableView()
        configureCustodyTableView()
    }

    func uncheckedChips() {
        [ordersChips, custodyChips, allChips].forEach({ $0.selected(false) })
    }

    // MARK: - Private

    private func changeTableViewVisibility() {
        let shouldHide = filterSelected == .order
        orderTableView.isHidden = !shouldHide
        custodyTableView.isHidden = shouldHide
    }

    private func configureOrderTableView() {
        orderTableView.isHidden = true
        orderTableView.delegate = self
        orderTableView.dataSource = orderTableViewDataSource
        orderTableView.register(
            PurchaseOrderTableViewCell.self,
            forCellReuseIdentifier: PurchaseOrderTableViewCell.identifier
        )
    }

    private func configureCustodyTableView() {
        custodyTableView.isHidden = true
        custodyTableView.delegate = self
        custodyTableView.dataSource = custodyTableViewDataSource
        custodyTableView.register(
            PurchaseCustodyTableViewCell.self,
            forCellReuseIdentifier: PurchaseCustodyTableViewCell.identifier
        )
    }

    private func setupOrderItemProvider(
        from tableView: UITableView,
        on indexPath: IndexPath,
        with items: PurchaseCustodyDTO.Card
    ) -> UITableViewCell {
        reuseOrderTableViewCell(from: tableView, on: indexPath, with: items)
    }

    private func setupCustodyItemProvider(
        from tableView: UITableView,
        on indexPath: IndexPath,
        with items: PurchaseCustodyDTO.Card
    ) -> UITableViewCell {
        reuseCustodyTableViewCell(from: tableView, on: indexPath, with: items)
    }

    private func reuseOrderTableViewCell(
        from tableView: UITableView,
        on indexPath: IndexPath,
        with items: PurchaseCustodyDTO.Card) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PurchaseOrderTableViewCell.identifier,
                for: indexPath
            ) as? PurchaseOrderTableViewCell else {
                return UITableViewCell()
            }
            cell.setup(with: items)
            return cell
        }

    private func reuseCustodyTableViewCell(
        from tableView: UITableView,
        on indexPath: IndexPath,
        with items: PurchaseCustodyDTO.Card) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PurchaseCustodyTableViewCell.identifier,
                for: indexPath
            ) as? PurchaseCustodyTableViewCell else {
                return UITableViewCell()
            }
            cell.setup(with: items)
            return cell
        }

    private func filterDidSelect(_ type: FilterType) {
        filterSelected = type
        delegate?.didSelect(type: type)
    }

    // MARK: - Public
    func setup(dto: PurchaseCustodyDTO) {
        headerView.setup(model: dto.header)
        if filterSelected == .order {
            orderTableViewDataSource.update(items: dto.cards, from: 0)
            orderTableView.reloadData()
        } else {
            custodyTableViewDataSource.update(items: dto.cards, from: 0)
            custodyTableView.reloadData()
        }
        changeTableViewVisibility()
    }
}

extension PurchaseCustodyView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(index: indexPath.row)
    }
}
