import UIKit

final class PurchaseCustodyTableViewCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        selectionStyle = .none
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.numberOfLines = 0
        
        stackView.axis = .vertical
        stackView.spacing = 8
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(stackView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with card: PurchaseCustodyDTO.Card) {
        titleLabel.text = card.title.value
        titleLabel.font = card.title.typograph.font
        titleLabel.textColor = card.title.typograph.color
        
        // Clear existing arranged subviews
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add field views
        for field in card.fields {
            let fieldView = createFieldView(field: field)
            stackView.addArrangedSubview(fieldView)
        }
    }
    
    private func createFieldView(field: PurchaseCustodyDTO.Field) -> UIView {
        let containerView = UIView()
        
        let labelLabel = UILabel()
        labelLabel.text = field.label?.value ?? ""
        labelLabel.font = field.label?.typograph.font ?? UIFont.systemFont(ofSize: 14)
        labelLabel.textColor = field.label?.typograph.color ?? .secondaryLabel
        
        let valueLabel = UILabel()
        valueLabel.text = field.value?.value ?? ""
        valueLabel.font = field.value?.typograph.font ?? UIFont.systemFont(ofSize: 16)
        valueLabel.textColor = field.value?.typograph.color ?? .label
        valueLabel.textAlignment = .right
        
        containerView.addSubview(labelLabel)
        containerView.addSubview(valueLabel)
        
        labelLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            labelLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: labelLabel.trailingAnchor, constant: 8)
        ])
        
        return containerView
    }
}

