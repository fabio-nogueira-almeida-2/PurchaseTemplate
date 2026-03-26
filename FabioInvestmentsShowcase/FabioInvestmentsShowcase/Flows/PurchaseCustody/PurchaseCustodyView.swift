import UIKit

protocol PurchaseCustodyViewDelegate: AnyObject {
    func didSelect(type: PurchaseCustodyView.FilterType)
    func investAction()
    func didSelect(index: Int)
}

final class PurchaseCustodyView: UIView {
    
    enum FilterType {
        case order
        case custody
        case all
    }
    
    weak var delegate: PurchaseCustodyViewDelegate?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerView = UIView()
    private let filterSegmentedControl = UISegmentedControl(items: ["Orders", "Custody", "All"])
    private let tableView = UITableView()
    private let investButton = UIButton(type: .system)
    
    private var dto: PurchaseCustodyDTO?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        // Setup scroll view
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Setup header
        contentView.addSubview(headerView)
        headerView.addSubview(filterSegmentedControl)
        
        // Setup table view
        contentView.addSubview(tableView)
        
        // Setup invest button
        contentView.addSubview(investButton)
        
        setupConstraints()
        setupActions()
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        filterSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        investButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Header view
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            // Segmented control
            filterSegmentedControl.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            filterSegmentedControl.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            // Table view
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 400),
            
            // Invest button
            investButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            investButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            investButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            investButton.heightAnchor.constraint(equalToConstant: 50),
            investButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        filterSegmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        investButton.addTarget(self, action: #selector(investButtonTapped), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PurchaseCustodyTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        investButton.setTitle("Invest Now", for: .normal)
        investButton.backgroundColor = .systemBlue
        investButton.setTitleColor(.white, for: .normal)
        investButton.layer.cornerRadius = 8
    }
    
    @objc private func segmentedControlChanged() {
        let selectedIndex = filterSegmentedControl.selectedSegmentIndex
        let filterType: FilterType
        switch selectedIndex {
        case 0: filterType = .order
        case 1: filterType = .custody
        case 2: filterType = .all
        default: filterType = .order
        }
        delegate?.didSelect(type: filterType)
    }
    
    @objc private func investButtonTapped() {
        delegate?.investAction()
    }
    
    func setup(dto: PurchaseCustodyDTO) {
        self.dto = dto
        tableView.reloadData()
    }
}

extension PurchaseCustodyView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dto?.cards.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PurchaseCustodyTableViewCell
        if let card = dto?.cards[indexPath.row] {
            cell.configure(with: card)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelect(index: indexPath.row)
    }
}

