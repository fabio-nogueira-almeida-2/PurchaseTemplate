import UIKit

final class PurchaseDetailTableViewCell: UITableViewCell {
    
    private let labelLabel = UILabel()
    private let valueLabel = UILabel()
    private let iconImageView = UIImageView()
    
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
        
        labelLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        labelLabel.textColor = .secondaryLabel
        
        valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        valueLabel.textColor = .label
        valueLabel.textAlignment = .right
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .systemBlue
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(labelLabel)
        contentView.addSubview(valueLabel)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        labelLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            labelLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            labelLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: labelLabel.trailingAnchor, constant: 8)
        ])
    }
    
    func setup(with field: PurchaseDetailDTO.Field) {
        labelLabel.text = field.label?.value ?? ""
        labelLabel.font = field.label?.typograph.font ?? UIFont.systemFont(ofSize: 14)
        labelLabel.textColor = field.label?.typograph.color ?? .secondaryLabel
        
        valueLabel.text = field.value?.value ?? ""
        valueLabel.font = field.value?.typograph.font ?? UIFont.systemFont(ofSize: 16)
        valueLabel.textColor = field.value?.typograph.color ?? .label
        
        iconImageView.image = UIImage(systemName: "info.circle")
    }
    
    func setup(with document: PurchaseDetailDTO.DocumentItem) {
        labelLabel.text = document.name
        labelLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        labelLabel.textColor = .label
        
        valueLabel.text = ""
        
        iconImageView.image = UIImage(systemName: document.imageIcon)
        iconImageView.tintColor = .systemBlue
        
        accessoryType = .disclosureIndicator
    }
}

