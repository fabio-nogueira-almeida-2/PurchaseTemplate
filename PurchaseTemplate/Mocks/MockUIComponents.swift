//
//  MockUIComponents.swift
//  PurchaseTemplate
//
//  SwiftUI/UIKit replacements for Apollo Framework components
//

import UIKit
import SwiftUI

// MARK: - ViewConfiguration Protocol

protocol ViewConfiguration {
    func buildViewHierarchy()
    func setupConstraints()
    func configureViews()
}

extension ViewConfiguration {
    func buildLayout() {
        buildViewHierarchy()
        setupConstraints()
        configureViews()
    }
}

// MARK: - Base ViewController

class ViewController<Interactor, ViewType: UIView>: UIViewController {
    let interactor: Interactor
    
    init(interactor: Interactor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }
    
    // MARK: - ViewConfiguration methods (can be overridden)
    func buildViewHierarchy() {
        // Override in subclasses
    }
    
    func setupConstraints() {
        // Override in subclasses
    }
    
    func configureViews() {
        // Override in subclasses
    }
    
    func buildLayout() {
        buildViewHierarchy()
        setupConstraints()
        configureViews()
    }
}

// MARK: - StatefulViewing Protocol

protocol StatefulViewing: AnyObject {
    var viewModel: StatefulViewModeling? { get set }
    var delegate: StatefulDelegate? { get set }
}

protocol StatefulViewModeling {}
protocol StatefulDelegate: AnyObject {}

protocol StatefulTransitionViewing {
    func statefulViewForLoading() -> StatefulViewing
}

extension UIViewController {
    func beginState() {
        // Show loading state
    }
    
    func endState() {
        // Hide loading state
    }
}

// MARK: - Text Component (replacement for Apollo Text)

class Text: UILabel {
    var value: String {
        get { text ?? "" }
        set { text = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func font(_ fontStyle: FontStyle) -> Self {
        self.font = fontStyle.uiFont
        return self
    }
    
    func bold() -> Self {
        if let font = self.font {
            self.font = UIFont.boldSystemFont(ofSize: font.pointSize)
        }
        return self
    }
    
    func foreground(color: Color) -> Self {
        self.textColor = color.uiColor
        return self
    }
    
    func lineLimit(_ limit: Int) -> Self {
        self.numberOfLines = limit
        return self
    }
}

// MARK: - FontStyle Protocol

protocol FontStyle {
    var uiFont: UIFont { get }
}

enum Font: FontStyle {
    case large
    case medium
    case small
    case body
    case note
    case label
    
    var uiFont: UIFont {
        switch self {
        case .large:
            return UIFont.systemFont(ofSize: 28, weight: .bold)
        case .medium:
            return UIFont.systemFont(ofSize: 22, weight: .semibold)
        case .small:
            return UIFont.systemFont(ofSize: 18, weight: .medium)
        case .body:
            return UIFont.systemFont(ofSize: 18, weight: .regular)
        case .note:
            return UIFont.systemFont(ofSize: 16, weight: .regular)
        case .label:
            return UIFont.systemFont(ofSize: 14, weight: .regular)
        }
    }
}

extension Font {
    var highlighted: Font {
        return self
    }
}

// MARK: - Color (replacement for Apollo Color)

enum Color {
    case primary900
    case primary800
    case primary500
    case primary200
    case grayScale900
    case grayScale800
    case grayScale200
    case feedbackSuccess500
    case feedbackWarning500
    case background00
    case white
    case black
    
    var uiColor: UIColor {
        switch self {
        case .primary900:
            return UIColor(hex: "#1A1A1A") ?? .black
        case .primary800:
            return UIColor(hex: "#333333") ?? .darkGray
        case .primary500:
            return UIColor(hex: "#21C25E") ?? .systemGreen
        case .primary200:
            return UIColor(hex: "#E8F5EE") ?? .lightGray
        case .grayScale900:
            return UIColor(hex: "#1A1A1A") ?? .black
        case .grayScale800:
            return UIColor(hex: "#666666") ?? .gray
        case .grayScale200:
            return UIColor(hex: "#E5E5E5") ?? .lightGray
        case .feedbackSuccess500:
            return UIColor(hex: "#21C25E") ?? .systemGreen
        case .feedbackWarning500:
            return UIColor(hex: "#FF6B35") ?? .systemOrange
        case .background00:
            return .white
        case .white:
            return .white
        case .black:
            return .black
        }
    }
    
    func opacity(_ level: OpacityLevel) -> UIColor {
        return uiColor.withAlphaComponent(level.alpha)
    }
}

enum OpacityLevel {
    case light
    case medium
    case heavy
    
    var alpha: CGFloat {
        switch self {
        case .light: return 0.1
        case .medium: return 0.5
        case .heavy: return 0.8
        }
    }
}

// MARK: - Space (replacement for Apollo Space)

enum Space: CGFloat {
    case base00 = 4
    case base02 = 8
    case base03 = 12
    case base04 = 16
    case base06 = 24
    case base07 = 28
    case base08 = 32
    case base10 = 40
    case base12 = 48
    
    var value: CGFloat {
        return rawValue
    }
}

// MARK: - Radius (replacement for Apollo Radius)

enum Radius {
    case small
    case medium
    case large
    case strong
    
    var value: CGFloat {
        switch self {
        case .small: return 4
        case .medium: return 8
        case .large: return 12
        case .strong: return 16
        }
    }
}

// MARK: - Button (replacement for Apollo Button)

class Button: UIButton {
    enum Style {
        case primary
        case secondary
        case tertiary
    }
    
    init(style: Style, label: String, action: @escaping () -> Void) {
        super.init(frame: .zero)
        setTitle(label, for: .normal)
        setupStyle(style)
        addAction(UIAction { _ in action() }, for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyle(_ style: Style) {
        switch style {
        case .primary:
            backgroundColor = Color.primary500.uiColor
            setTitleColor(.white, for: .normal)
            layer.cornerRadius = 8
        case .secondary:
            backgroundColor = .clear
            setTitleColor(Color.primary500.uiColor, for: .normal)
            layer.borderWidth = 1
            layer.borderColor = Color.primary500.uiColor.cgColor
            layer.cornerRadius = 8
        case .tertiary:
            backgroundColor = .clear
            setTitleColor(Color.primary500.uiColor, for: .normal)
        }
    }
}

// MARK: - Avatar (replacement for Apollo Avatar)

class Avatar: UIImageView {
    enum AvatarStyle {
        case circle
        case square
    }
    
    enum AvatarSize {
        case small
        case medium
        case large
        
        var size: CGFloat {
            switch self {
            case .small: return 32
            case .medium: return 40
            case .large: return 56
            }
        }
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        contentMode = .scaleAspectFit
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func style(_ style: AvatarStyle) -> Self {
        switch style {
        case .circle:
            layer.cornerRadius = bounds.width / 2
        case .square:
            layer.cornerRadius = 0
        }
        return self
    }
    
    func size(_ size: AvatarSize) -> Self {
        // Size will be set via constraints, but store for reference
        return self
    }
    
    func background(color: UIColor) -> Self {
        backgroundColor = color
        return self
    }
    
    func foreground(color: Color) -> Self {
        tintColor = color.uiColor
        return self
    }
    
    func image(_ icon: Icon, _ color: Color) -> Self {
        self.image = icon.image
        self.tintColor = color.uiColor
        return self
    }
}

// MARK: - Icon (replacement for Apollo Icon)

enum Icon: String {
    case infoCircle
    case invoice
    case feedbackDangerMono
    case documentInfo
    case angleRightB
    case filter
    case shieldCheckmark = "shield.checkmark"
    case chartLineUptrend = "chart.line.uptrend.xyaxis"
    case questionmarkCircle = "questionmark.circle"
    case docText = "doc.text"
    
    var image: UIImage? {
        switch self {
        case .infoCircle:
            return UIImage(systemName: "info.circle")
        case .invoice:
            return UIImage(systemName: "doc.text")
        case .feedbackDangerMono:
            return UIImage(systemName: "exclamationmark.triangle")
        case .documentInfo:
            return UIImage(systemName: "doc.text")
        case .angleRightB:
            return UIImage(systemName: "chevron.right")
        case .filter:
            return UIImage(systemName: "line.3.horizontal.decrease.circle")
        case .shieldCheckmark:
            return UIImage(systemName: "shield.checkmark")
        case .chartLineUptrend:
            return UIImage(systemName: "chart.line.uptrend.xyaxis")
        case .questionmarkCircle:
            return UIImage(systemName: "questionmark.circle")
        case .docText:
            return UIImage(systemName: "doc.text")
        }
    }
}

// MARK: - UIView Extensions

extension UIView {
    func background(color: Color) {
        backgroundColor = color.uiColor
    }
    
    func corner(radius: Radius) {
        layer.cornerRadius = radius.value
        clipsToBounds = true
    }
}

// MARK: - UIBarButtonBuilder

// UIBarButtonBuilder moved to MockMissingTypes.swift

// MARK: - EdgeInsets

typealias EdgeInsets = UIEdgeInsets

extension UIEdgeInsets {
    static let rootView = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
}

// MARK: - UIImageView Extension

extension UIImageView {
    func setImage(url: URL) {
        // Simple implementation - in production use SDWebImage or similar
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }
}

// MARK: - Strings (Mock)

enum Strings {
    enum Purchase {
        enum Welcome {
            static let tip = "Dica: Você pode acompanhar seus investimentos na área de Custódia"
        }
        
        enum List {
            static let headerTitle = "Ofertas Disponíveis"
        }
        
        enum Custody {
            static let activeChips = "Ativos"
            static let processingChips = "Em Processamento"
            static let allChips = "Todos"
            static let investButton = "Investir"
        }
        
        enum Input {
            static let title = "Input Value"
        }
        
        enum Detail {
            static let investButton = "Investir"
            static let documents = "Documentos"
        }
        
        enum Confirmation {
            static let title = "Confirmar Investimento"
            static let button = "Confirmar"
            static let originalValue = "Valor Original"
            static let quantity = "Quantidade"
            static let value = "Valor"
            static let type = "Tipo"
            static let product = "Produto"
            static let loading = "Processando..."
        }
    }
    
    enum BalanceTransfer {
        enum InsertValueTransfer {
            static func walletValue(_ value: String) -> String {
                return "Saldo disponível: \(value)"
            }
            
            static let missingValue = "Por favor, insira um valor"
            static func valueExceeded(_ value: String) -> String {
                return "Valor excedido. Máximo: \(value)"
            }
            static func underMinValue(_ value: String) -> String {
                return "Valor abaixo do mínimo. Mínimo: \(value)"
            }
            static let allValue = "Todo o saldo"
            static func addValue(_ value: String) -> String {
                return "Adicionar \(value)"
            }
        }
    }
    
    enum Royalty {
        enum Result {
            static let title = "Investimento Realizado"
            static let detail = "Seu investimento foi processado com sucesso!"
            static let primaryButton = "Ver Ofertas"
            static let secondaryButton = "Ver Extrato"
        }
    }
}

// MARK: - UIColor Extension

extension UIColor {
    convenience init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}

// MARK: - SnapKit-like constraints (simplified)

extension UIView {
    var snp: ConstraintMaker {
        return ConstraintMaker(view: self)
    }
}

class ConstraintMaker {
    weak var view: UIView?
    private var constraints: [NSLayoutConstraint] = []
    private var pendingItems: [ConstraintItem] = []
    
    init(view: UIView) {
        self.view = view
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func makeConstraints(_ closure: (ConstraintMaker) -> Void) {
        closure(self)
        // Apply constraints using modern API
        if !constraints.isEmpty {
            // Use NSLayoutConstraint.activate() which handles finding the right view automatically
            NSLayoutConstraint.activate(constraints)
        }
        constraints.removeAll()
        pendingItems.removeAll()
    }
    
    var leading: ConstraintItem { 
        let item = ConstraintItem(view: view, attribute: .leading, maker: self)
        pendingItems.append(item)
        return item
    }
    var trailing: ConstraintItem { 
        let item = ConstraintItem(view: view, attribute: .trailing, maker: self)
        pendingItems.append(item)
        return item
    }
    var top: ConstraintItem { 
        let item = ConstraintItem(view: view, attribute: .top, maker: self)
        pendingItems.append(item)
        return item
    }
    var bottom: ConstraintItem { 
        let item = ConstraintItem(view: view, attribute: .bottom, maker: self)
        pendingItems.append(item)
        return item
    }
    var centerX: ConstraintItem { 
        let item = ConstraintItem(view: view, attribute: .centerX, maker: self)
        pendingItems.append(item)
        return item
    }
    var centerY: ConstraintItem { 
        let item = ConstraintItem(view: view, attribute: .centerY, maker: self)
        pendingItems.append(item)
        return item
    }
    var width: ConstraintItem { 
        let item = ConstraintItem(view: view, attribute: .width, maker: self)
        pendingItems.append(item)
        return item
    }
    var height: ConstraintItem { 
        let item = ConstraintItem(view: view, attribute: .height, maker: self)
        pendingItems.append(item)
        return item
    }
    var edges: ConstraintItem { 
        let item = ConstraintItem(view: view, attribute: .edges, maker: self)
        pendingItems.append(item)
        return item
    }
    var size: ConstraintItem { 
        let item = ConstraintItem(view: view, attribute: .size, maker: self)
        pendingItems.append(item)
        return item
    }
    
    func addConstraint(_ constraint: NSLayoutConstraint) {
        constraints.append(constraint)
    }
    
    // Helper to find common ancestor for constraint installation
    func findCommonAncestor(for view1: UIView?, and view2: UIView?) -> UIView? {
        guard let v1 = view1, let v2 = view2 else { return nil }
        
        // If one is ancestor of the other, return the ancestor
        var current: UIView? = v1
        while current != nil {
            if current == v2 {
                return v2
            }
            current = current?.superview
        }
        
        current = v2
        while current != nil {
            if current == v1 {
                return v1
            }
            current = current?.superview
        }
        
        // Find common ancestor
        var ancestors1 = Set<UIView>()
        current = v1
        while current != nil {
            ancestors1.insert(current!)
            current = current?.superview
        }
        
        current = v2
        while current != nil {
            if ancestors1.contains(current!) {
                return current
            }
            current = current?.superview
        }
        
        return nil
    }
}

class ConstraintItem {
    weak var view: UIView?
    let attribute: NSLayoutConstraint.Attribute
    weak var maker: ConstraintMaker?
    var constant: CGFloat = 0
    private var applied: Bool = false
    
    init(view: UIView?, attribute: NSLayoutConstraint.Attribute, maker: ConstraintMaker) {
        self.view = view
        self.attribute = attribute
        self.maker = maker
    }
    
    // Create a copy for chaining
    init(copying other: ConstraintItem) {
        self.view = other.view
        self.attribute = other.attribute
        self.maker = other.maker
        self.constant = other.constant
    }
    
    func equalTo(_ item: ConstraintItem) -> ConstraintItem {
        guard !applied, let view = view, let itemView = item.view else { return self }
        applied = true
        let finalConstant = constant + item.constant
        let constraint = NSLayoutConstraint(
            item: view,
            attribute: attribute,
            relatedBy: .equal,
            toItem: itemView,
            attribute: item.attribute,
            multiplier: 1.0,
            constant: finalConstant
        )
        maker?.addConstraint(constraint)
        return self
    }
    
    func equalToSuperview() -> ConstraintItem {
        guard !applied, let view = view, let superview = view.superview else {
            // If no superview yet, return self for chaining but don't apply
            // The constraint will be created when makeConstraints completes
            return self
        }
        applied = true
        
        // Special handling for .edges attribute
        if attribute == .edges {
            // Create 4 constraints for edges
            let constraints = [
                NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: constant),
                NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: constant),
                NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: -constant),
                NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: -constant)
            ]
            constraints.forEach { maker?.addConstraint($0) }
            return self
        }
        
        // Regular constraint
        let constraint = NSLayoutConstraint(
            item: view,
            attribute: attribute,
            relatedBy: .equal,
            toItem: superview,
            attribute: attribute,
            multiplier: 1.0,
            constant: constant
        )
        constraint.isActive = true
        maker?.addConstraint(constraint)
        return self
    }
    
    func equalTo(_ value: CGFloat) {
        guard !applied, let view = view else { return }
        applied = true
        
        // Special handling for .size attribute
        if attribute == .size {
            // Create width and height constraints
            let widthConstraint = NSLayoutConstraint(
                item: view,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: value
            )
            let heightConstraint = NSLayoutConstraint(
                item: view,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: value
            )
            maker?.addConstraint(widthConstraint)
            maker?.addConstraint(heightConstraint)
            return
        }
        
        // Regular constraint
        let constraint = NSLayoutConstraint(
            item: view,
            attribute: attribute,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: value
        )
        maker?.addConstraint(constraint)
    }
    
    func offset(_ value: CGFloat) -> ConstraintItem {
        guard let maker = maker else { return self }
        let newItem = ConstraintItem(view: view, attribute: attribute, maker: maker)
        newItem.constant = value
        return newItem
    }
    
    func inset(_ value: CGFloat) -> ConstraintItem {
        guard let maker = maker else { return self }
        let newItem = ConstraintItem(view: view, attribute: attribute, maker: maker)
        if attribute == .leading || attribute == .top {
            newItem.constant = value
        } else if attribute == .trailing || attribute == .bottom {
            newItem.constant = -value
        } else if attribute == .edges {
            newItem.constant = value
        }
        return newItem
    }
    
    private func applyConstraintIfNeeded() {
        guard !applied, let view = view, let superview = view.superview else { return }
        applied = true
        
        if attribute == .edges {
            // Handle edges case
            let constraints = [
                NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: constant),
                NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: constant),
                NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: -constant),
                NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: -constant)
            ]
            constraints.forEach { maker?.addConstraint($0) }
        } else {
            let finalConstant: CGFloat
            if attribute == .leading || attribute == .top {
                finalConstant = constant
            } else if attribute == .trailing || attribute == .bottom {
                finalConstant = -constant
            } else {
                finalConstant = constant
            }
            let constraint = NSLayoutConstraint(
                item: view,
                attribute: attribute,
                relatedBy: .equal,
                toItem: superview,
                attribute: attribute,
                multiplier: 1.0,
                constant: finalConstant
            )
            maker?.addConstraint(constraint)
        }
    }
    
    // Called when chain ends without modifiers
    func apply() {
        applyConstraintIfNeeded()
    }
}

extension NSLayoutConstraint.Attribute {
    static let edges = NSLayoutConstraint.Attribute.notAnAttribute
    static let size = NSLayoutConstraint.Attribute.notAnAttribute
}

// MARK: - UIViewController Extension for Feedback

extension UIViewController {
    func display(feedback: InvestmentsHubFeedback, primaryAction: @escaping () -> Void, secondaryAction: (() -> Void)? = nil) {
        // Prevent presenting alert if view controller is already presenting something
        guard presentedViewController == nil else {
            print("⚠️ Cannot present alert: view controller is already presenting")
            return
        }
        
        let alert = UIAlertController(
            title: "Erro",
            message: feedbackMessage(feedback),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Tentar novamente", style: .default) { _ in
            primaryAction()
        })
        
        if let secondaryAction = secondaryAction {
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel) { _ in
                secondaryAction()
            })
        }
        
        present(alert, animated: true)
    }
    
    private func feedbackMessage(_ feedback: InvestmentsHubFeedback) -> String {
        switch feedback {
        case .connectionFailureError:
            return "Erro de conexão. Verifique sua internet e tente novamente."
        case .genericError:
            return "Ocorreu um erro. Tente novamente mais tarde."
        case .maintenanceError:
            return "Serviço em manutenção. Tente novamente mais tarde."
        }
    }
}

