// import Apollo // Commented out - replaced with mock implementation
// import SkeletonView // Commented out - replaced with mock implementation
// import UI // Commented out - replaced with mock implementation
import UIKit

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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    private lazy var custodyTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
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
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            // Header will size itself based on content - ensure it doesn't expand infinitely
        }
        chipsScrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(Space.base03.rawValue)
            $0.leading.equalToSuperview().inset(Space.base04.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base04.rawValue)
            $0.height.equalTo(40) // Fixed height for chips scroll view
        }
        chipsStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        orderTableView.snp.makeConstraints {
            $0.top.equalTo(chipsScrollView.snp.bottom).offset(Space.base02.rawValue)
            $0.leading.equalToSuperview().inset(Space.base04.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base04.rawValue)
            $0.bottom.equalTo(footer.snp.top).inset(Space.base04.rawValue)
        }
        custodyTableView.snp.makeConstraints {
            $0.top.equalTo(orderTableView.snp.top)
            $0.leading.equalTo(orderTableView.snp.leading)
            $0.trailing.equalTo(orderTableView.snp.trailing)
            $0.bottom.equalTo(orderTableView.snp.bottom)
        }
        footer.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(Space.base12.rawValue)
        }
        investButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Space.base03.rawValue)
            $0.leading.equalToSuperview().inset(Space.base04.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base04.rawValue)
            $0.bottom.equalToSuperview().inset(Space.base04.rawValue)
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
        // Show order table for .order and .all filters
        // Show custody table only for .custody filter
        switch filterSelected {
        case .order, .all:
            orderTableView.isHidden = false
            custodyTableView.isHidden = true
        case .custody:
            orderTableView.isHidden = true
            custodyTableView.isHidden = false
        }
    }

    private func configureOrderTableView() {
        orderTableView.delegate = self
        orderTableView.dataSource = orderTableViewDataSource
        orderTableView.register(
            PurchaseOrderTableViewCell.self,
            forCellReuseIdentifier: "PurchaseOrderTableViewCell"
        )
        orderTableView.isHidden = true // Will be shown by changeTableViewVisibility()
    }

    private func configureCustodyTableView() {
        custodyTableView.delegate = self
        custodyTableView.dataSource = custodyTableViewDataSource
        custodyTableView.register(
            PurchaseCustodyTableViewCell.self,
            forCellReuseIdentifier: "PurchaseCustodyTableViewCell"
        )
        custodyTableView.isHidden = true // Will be shown by changeTableViewVisibility()
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
                withIdentifier: "PurchaseOrderTableViewCell",
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
                withIdentifier: "PurchaseCustodyTableViewCell",
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
        print("📊 PurchaseCustodyView.setup() called with \(dto.cards.count) cards, filterSelected: \(filterSelected)")
        headerView.setup(model: dto.header)
        
        // Update both data sources to ensure data is available
        orderTableViewDataSource.update(items: dto.cards, from: 0)
        custodyTableViewDataSource.update(items: dto.cards, from: 0)
        print("📊 Updated data sources with \(dto.cards.count) cards")
        
        // ALWAYS defer reload until view is in window to avoid layout warnings
        // Even if window != nil, the table view might not be properly laid out yet
        print("📊 Deferring table reload until view appears")
        setNeedsReload = true
    }
    
    // Flag to track if we need to reload tables when view appears
    private var setNeedsReload = false
    
    // Call this when view is added to window to reload tables if needed
    func reloadTablesIfNeeded() {
        guard setNeedsReload else { return }
        
        // Ensure the view itself is in a window
        guard window != nil else {
            print("📊 View not yet in window, will retry")
            return
        }
        
        // Set visibility first (this is safe even if not in window yet)
        changeTableViewVisibility()
        
        // Determine which table view should be visible
        let visibleTableView: UITableView?
        switch filterSelected {
        case .order, .all:
            visibleTableView = orderTableView
        case .custody:
            visibleTableView = custodyTableView
        }
        
        // Only reload the visible table view if it's actually in the window
        // This prevents layout warnings for hidden table views
        if let tableView = visibleTableView, tableView.window != nil {
            setNeedsReload = false
            print("📊 Reloading \(tableView == orderTableView ? "orderTableView" : "custodyTableView") now that it's in window")
            tableView.reloadData()
        } else {
            print("📊 Visible table view not yet in window, will retry")
        }
    }
}

extension PurchaseCustodyView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(index: indexPath.row)
    }
}

