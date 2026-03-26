//
//  MockMissingTypes.swift
//  PurchaseTemplate
//
//  Mock implementations for missing types and protocols
//

import Foundation
import UIKit
import ObjectiveC

// MARK: - PurchaseOrderModel

struct PurchaseOrderModel {
    let offerId: String
    let productId: String
    var value: Double
    var quantity: Int
    let tokenValue: Double
    let typeName: String
    let productName: String
}

// MARK: - Missing Protocols

protocol HasConsumerManager {
    var consumerManager: ConsumerManagerProtocol { get }
}

protocol ConsumerManagerProtocol {
    var consumerId: Int { get }
}

protocol HasAuth {
    var auth: AuthProtocol { get }
}

protocol AuthProtocol {
    func authenticate(completion: @escaping (Result<String, Error>) -> Void)
}

// MARK: - Missing UI Types

struct InvestmentsLoadingViewModel {
    let illustration: IllustrationType
    let text: String
    let loadingTimeInSeconds: Int
}

enum IllustrationType {
    case moneyWalletCoins
}

protocol InvestmentsLoadingViewProtocol {
    var loadingView: InvestmentsLoadingView { get }
    func startLoadingView()
    func stopLoadingView()
}

class InvestmentsLoadingView: UIView {
    func set(viewModel: InvestmentsLoadingViewModel) {
        // Mock implementation
    }
}

extension ViewController: InvestmentsLoadingViewProtocol {
    var loadingView: InvestmentsLoadingView {
        // Create a lazy loading view if needed
        if let existing = objc_getAssociatedObject(self, &AssociatedKeys.loadingView) as? InvestmentsLoadingView {
            return existing
        }
        let view = InvestmentsLoadingView()
        objc_setAssociatedObject(self, &AssociatedKeys.loadingView, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return view
    }
    
    func startLoadingView() {
        view.addSubview(loadingView)
        loadingView.frame = view.bounds
        loadingView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
    }
    
    func stopLoadingView() {
        loadingView.removeFromSuperview()
    }
}

private struct AssociatedKeys {
    static var loadingView = "loadingView"
}

class UIBarButtonBuilder {
    static func close(action: @escaping () -> Void) -> UIBarButtonBuilder {
        return UIBarButtonBuilder(action: action)
    }
    
    private let action: () -> Void
    
    private init(action: @escaping () -> Void) {
        self.action = action
    }
    
    func build() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .close, target: nil, action: #selector(buttonTapped))
    }
    
    @objc private func buttonTapped() {
        action()
    }
}

// MARK: - StringWithTypograph Extension for Text

extension Text {
    func setTypograph(_ typograph: String) {
        // Convert string to PurchaseTypograph and apply
        if let purchaseTypograph = PurchaseTypograph(rawValue: typograph) {
            setTypograph(purchaseTypograph)
        } else {
            // Fallback based on style string
            switch typograph.lowercased() {
            case "header1", "header2", "header3", "header4":
                self.font(Font.large)
            case "body1", "body2":
                self.font(Font.body)
            case "note":
                self.font(Font.note)
            case "label":
                self.font(Font.label)
            default:
                self.font(Font.body)
            }
        }
    }
}

// MARK: - TableViewDataSource

class TableViewDataSource<Section: Hashable, Item: Hashable>: NSObject, UITableViewDataSource {
    weak var view: UITableView?
    private var sections: [Section] = []
    private var items: [Section: [Item]] = [:]
    var itemProvider: ((UITableView, IndexPath, Item) -> UITableViewCell?)?
    
    init(view: UITableView) {
        self.view = view
        super.init()
    }
    
    func add(section: Section) {
        if !sections.contains(where: { $0 == section }) {
            sections.append(section)
            items[section] = []
        }
    }
    
    func update(items: [Item], from section: Section) {
        self.items[section] = items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < sections.count else { return 0 }
        let sectionKey = sections[section]
        return items[sectionKey]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < sections.count else {
            return UITableViewCell()
        }
        let sectionKey = sections[indexPath.section]
        guard let sectionItems = items[sectionKey],
              indexPath.row < sectionItems.count else {
            return UITableViewCell()
        }
        let item = sectionItems[indexPath.row]
        return itemProvider?(tableView, indexPath, item) ?? UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
}

// MARK: - Missing Types for InputValue Flow

protocol InsertValueTransferPresenting {
    func show(balance: Double, isProgressBarVisible: Bool)
    func confirmTransactionScreen(amount: Double)
    func noBalanceInserted()
    func balanceExceeded(maxBalance: Double)
    func valueUnderMinimun(minimum: Double)
    func startLoading()
    func stopLoading()
}

protocol InsertValueTransferInteracting {
    func load()
    func didTapContinueButton(amount: Double)
}

protocol InsertValueTransferDisplaying: AnyObject {
    func display(viewModel: InsertValueTransferViewModel)
    func displayError(message: String)
    func startLoading()
    func stopLoading()
}

struct InsertValueTransferViewModel {
    let title: String
    let description: String
    let amountFormatted: String
    let chips: [Chip]
    let isProgressVisible: Bool
    
    struct Chip {
        let label: String
        let value: Double
        let operation: ChipOperation
        var analyticsText: String?
        
        init(label: String, value: Double, operation: ChipOperation, analyticsText: String? = nil) {
            self.label = label
            self.value = value
            self.operation = operation
            self.analyticsText = analyticsText
        }
    }
    
    enum ChipOperation {
        case equal
        case add
    }
}

struct PurchaseOrderRuleModel: Decodable, Equatable {
    let balance: Double?
    let balanceOrigin: String
    let balances: Balances
    let rules: Rules
    
    struct Balances: Decodable, Equatable {
        let wallet: Double?
        let invest: Double?
    }
    
    struct Rules: Decodable, Equatable {
        let value: ValueRules?
    }
    
    struct ValueRules: Decodable, Equatable {
        let min: Int
        let max: Int?
        let multiple: Int
    }
}

class InsertValueTransferViewController: UIViewController {
    let interactor: InsertValueTransferInteracting
    let analytics: InsertValueTransferAnalyticsImpl
    
    private var currentAmount: Double = 0.0
    private var viewModel: InsertValueTransferViewModel?
    
    // MARK: - Views
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Space.base04.rawValue
        view.distribution = .fill
        view.layoutMargins = EdgeInsets.rootView
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    private lazy var titleLabel: Text = {
        let view = Text()
        view.font(Font.large)
        view.bold()
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var descriptionLabel: Text = {
        let view = Text()
        view.font(Font.body)
        view.foreground(color: .grayScale800)
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var amountTextField: UITextField = {
        let field = UITextField()
        field.font = UIFont.systemFont(ofSize: 18)
        field.borderStyle = .roundedRect
        field.keyboardType = .decimalPad
        field.placeholder = "R$ 0,00"
        field.textAlignment = .center
        return field
    }()
    
    private lazy var chipsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = Space.base02.rawValue
        view.distribution = .fillEqually
        return view
    }()
    
    private lazy var continueButton: Button = {
        let button = Button(style: .primary, label: "Continuar") { [weak self] in
            guard let self = self else { return }
            self.interactor.didTapContinueButton(amount: self.currentAmount)
        }
        return button
    }()
    
    init(interactor: InsertValueTransferInteracting, analytics: InsertValueTransferAnalyticsImpl) {
        self.interactor = interactor
        self.analytics = analytics
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor.load()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Valor do Investimento"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Space.base04.rawValue)
            $0.leading.equalToSuperview().inset(Space.base04.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base04.rawValue)
            $0.bottom.equalToSuperview().inset(Space.base04.rawValue)
            $0.width.equalTo(scrollView.snp.width).offset(-Space.base04.rawValue * 2)
        }
        
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(amountTextField)
        contentStackView.addArrangedSubview(chipsStackView)
        contentStackView.addArrangedSubview(continueButton)
        
        amountTextField.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        continueButton.snp.makeConstraints {
            $0.height.equalTo(Layout.Size.button)
        }
        
        // Add text field delegate
        amountTextField.delegate = self
        amountTextField.addTarget(self, action: #selector(amountChanged), for: .editingChanged)
    }
    
    @objc private func amountChanged() {
        let text = amountTextField.text ?? ""
        let cleaned = text.replacingOccurrences(of: "R$", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: ".")
        currentAmount = Double(cleaned) ?? 0.0
    }
    
    private func setupChips(_ chips: [InsertValueTransferViewModel.Chip]) {
        chipsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for chip in chips {
            let chipButton = UIButton(type: .system)
            chipButton.setTitle(chip.label, for: .normal)
            chipButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            chipButton.backgroundColor = Color.primary200.uiColor.withAlphaComponent(0.1)
            chipButton.layer.cornerRadius = 8
            chipButton.addAction(UIAction { [weak self] _ in
                self?.handleChipTap(chip: chip)
            }, for: .touchUpInside)
            
            chipsStackView.addArrangedSubview(chipButton)
        }
    }
    
    private func handleChipTap(chip: InsertValueTransferViewModel.Chip) {
        switch chip.operation {
        case .equal:
            currentAmount = chip.value
        case .add:
            currentAmount += chip.value
        }
        updateAmountDisplay()
    }
    
    private func updateAmountDisplay() {
        if let formatted = currentAmount.toCurrencyString() {
            amountTextField.text = formatted
        }
    }
}

class InsertValueTransferAnalyticsImpl {
    enum AnalyticsType {
        case `in`
        case `out`
    }
    
    let type: AnalyticsType
    var interactor: InsertValueTransferInteracting?
    
    init(type: AnalyticsType, dependencies: HasAnalytics) {
        self.type = type
    }
}

// MARK: - InsertValueTransferViewController Extension

extension InsertValueTransferViewController: InsertValueTransferDisplaying {
    func display(viewModel: InsertValueTransferViewModel) {
        self.viewModel = viewModel
        titleLabel.value = viewModel.title
        descriptionLabel.value = viewModel.description
        amountTextField.text = viewModel.amountFormatted
        currentAmount = Double(viewModel.amountFormatted.replacingOccurrences(of: "R$", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: ".")) ?? 0.0
        setupChips(viewModel.chips)
    }
    
    func displayError(message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func startLoading() {
        // Show loading indicator if needed
    }
    
    func stopLoading() {
        // Hide loading indicator if needed
    }
}

extension InsertValueTransferViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Allow text changes for amount input
        return true
    }
}

// MARK: - Layout Constants
private extension InsertValueTransferViewController {
    enum Layout {
        enum Size {
            static let button: CGFloat = 48
        }
    }
}

extension Double {
    func toCurrencyString(maxFractionDigits: Int = 2) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = maxFractionDigits
        return formatter.string(from: NSNumber(value: self))
    }
}

// MARK: - Chips (Mock)

class Chips: UIView {
    private var _isToogle = false
    private var _isSelected = false
    private var _text: String = ""
    private var _action: ((Bool) -> Void)?
    
    var isToogle: Bool {
        get { _isToogle }
        set { _isToogle = newValue }
    }
    
    var selected: Bool {
        get { _isSelected }
        set { _isSelected = newValue }
    }
    
    init(isToogle: Bool = false) {
        super.init(frame: .zero)
        self._isToogle = isToogle
        backgroundColor = Color.grayScale200.uiColor
        layer.cornerRadius = 8
        translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTap() {
        if _isToogle {
            _isSelected.toggle()
        }
        _action?(_isSelected)
        updateAppearance()
    }
    
    func selected(_ value: Bool) -> Chips {
        _isSelected = value
        updateAppearance()
        return self
    }
    
    func text(_ text: String) -> Chips {
        _text = text
        // Add label if needed
        return self
    }
    
    func action(_ handler: @escaping (Bool) -> Void) -> Chips {
        _action = handler
        return self
    }
    
    private func updateAppearance() {
        if _isSelected {
            backgroundColor = Color.primary500.uiColor.withAlphaComponent(0.1)
            layer.borderWidth = 1
            layer.borderColor = Color.primary500.uiColor.cgColor
        } else {
            backgroundColor = Color.grayScale200.uiColor
            layer.borderWidth = 0
        }
    }
}

extension String {
    func replacingCurrencySpaceWithUnderscore() -> String {
        return self.replacingOccurrences(of: " ", with: "_")
    }
    
    func removeDot() -> String {
        return self.replacingOccurrences(of: ".", with: "")
    }
}

// MARK: - Missing Strings (moved to MockUIComponents)

// Strings enum is defined in MockUIComponents.swift

// MARK: - CoreServicing Extension

extension CoreServicing {
    func request<T: Decodable>(
        endpoint: InvestmentsEndpoint,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask? {
        let decoder = JSONDecoder.useDefaultKeys()
        return request(endpoint: endpoint, decoder: decoder, completion: completion)
    }
}

