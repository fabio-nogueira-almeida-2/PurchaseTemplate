import UIKit

final class PurchaseListTableViewCell: UITableViewCell, ViewConfiguration {
    static let identifier = "PurchaseListTableViewCell"
    
    // MARK - Properties

    // MARK - View
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.grayScale200.uiColor
        view.layer.cornerRadius = 8
        return view
    }()

    private lazy var containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Space.base02.rawValue
        return view
    }()

    // MARK - Override
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        containerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // MARK - ViewConfiguration
    func buildViewHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(containerStackView)
    }

    func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Space.base02.rawValue)
            $0.top.equalToSuperview().offset(Space.base02.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base02.rawValue)
            $0.bottom.equalToSuperview().inset(Space.base02.rawValue)
        }
        containerStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Space.base02.rawValue)
            $0.top.equalToSuperview().offset(Space.base02.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base02.rawValue)
            $0.bottom.equalToSuperview().inset(Space.base02.rawValue)
        }
    }

    func configureViews() {
        selectionStyle = .none
    }

    func setup(with model: PurchaseListDTO.Card) {
        createFieldViews(model.fields)
    }

    // MARK: - Private
    private func createFieldViews(_ fields: [PurchaseListDTO.Field]) {
        fields.forEach { field in
            let titleLabel = Text()
            titleLabel.value = field.label?.value ?? ""
            if let titleTypograph = field.label?.typograph.rawValue {
                titleLabel.setTypograph(titleTypograph)
            }
            let detailLabel = Text()
            detailLabel.value = field.value?.value ?? ""
            if let detailTypograph = field.value?.typograph.rawValue {
                detailLabel.setTypograph(detailTypograph)
            }
            detailLabel.textAlignment = .right
            let stackView = createFieldStackView()
            stackView.addArrangedSubview(titleLabel)
            stackView.addArrangedSubview(detailLabel)
            containerStackView.addArrangedSubview(stackView)
        }
    }

    private func createFieldStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = Space.base02.rawValue
        view.distribution = .fill
        return view
    }
}
