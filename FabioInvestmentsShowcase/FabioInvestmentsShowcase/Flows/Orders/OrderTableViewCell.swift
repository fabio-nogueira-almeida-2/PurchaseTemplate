import UIKit

final class OrderTableViewCell: UITableViewCell {
    
    private let productLabel = UILabel()
    private let amountLabel = UILabel()
    private let statusLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        accessoryType = .disclosureIndicator
        
        productLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        productLabel.textColor = .label
        
        amountLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        amountLabel.textColor = .systemGreen
        
        statusLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        statusLabel.textColor = .secondaryLabel
        
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        dateLabel.textColor = .tertiaryLabel
        
        contentView.addSubview(productLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(dateLabel)
        
        productLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            productLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productLabel.trailingAnchor.constraint(equalTo: amountLabel.leadingAnchor, constant: -8),
            
            amountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            amountLabel.widthAnchor.constraint(equalToConstant: 100),
            
            statusLabel.topAnchor.constraint(equalTo: productLabel.bottomAnchor, constant: 4),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -8),
            
            dateLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 4),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with order: OrderModel) {
        productLabel.text = order.product
        amountLabel.text = order.amount
        statusLabel.text = order.status
        dateLabel.text = order.date
        
        // Set status color based on status
        switch order.status {
        case "Completed":
            statusLabel.textColor = .systemGreen
        case "Pending":
            statusLabel.textColor = .systemOrange
        case "Processing":
            statusLabel.textColor = .systemBlue
        default:
            statusLabel.textColor = .secondaryLabel
        }
    }
}
