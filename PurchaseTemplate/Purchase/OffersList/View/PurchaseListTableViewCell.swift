import Apollo
import UI

final class PurchaseListTableViewCell: UITableViewCell, ViewConfiguration {
    // MARK - Properties

    // MARK - View
    private lazy var containerView: UIView = {
        let view = UIView()
        view.background(color: .grayScale050)
        view.corner(radius: .large)
        return view
    }()

    private lazy var containerStackView = UIStackView()

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
        containerStackView.removeAllArrangedSubviews()
    }

    // MARK - ViewConfiguration
    func buildViewHierarchy() {
        addSubview(containerView)
        containerView.addSubview(containerStackView)
    }

    func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(Space.base02.rawValue)
            $0.trailing.bottom.equalToSuperview().inset(Space.base02.rawValue)
        }
        containerStackView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(Space.base02.rawValue)
            $0.trailing.bottom.equalToSuperview().inset(Space.base02.rawValue)
        }
    }

    func configureViews() {
        selectionStyle = .none
        containerStackView.axis = .vertical
        containerStackView.spacing = Space.base01.rawValue
    }

    func setup(with model: PurchaseListDTO.Card) {
        createFieldViews(model.fields)
    }

    // MARK: - Private
    private func createFieldViews(_ fields: [PurchaseListDTO.Field]) {
        fields.forEach { field in
            let titleLabel = Text(field.label?.value ?? "")
            if let titleTypograph = field.label?.typograph {
                titleLabel.setTypograph(titleTypograph)
            }
            let detailLabel = Text(field.value?.value ?? "")
            if let detailTypograph = field.value?.typograph {
                detailLabel.setTypograph(detailTypograph)
            }
            detailLabel.multilineTextAlignment(.right)
            let stackView = createFieldStackView()
            stackView.addArrangedSubview(titleLabel)
            stackView.addArrangedSubview(detailLabel)
            containerStackView.addArrangedSubview(stackView)
        }
    }

    private func createFieldStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = Space.base01.rawValue
        view.distribution = .fill
        return view
    }
}
