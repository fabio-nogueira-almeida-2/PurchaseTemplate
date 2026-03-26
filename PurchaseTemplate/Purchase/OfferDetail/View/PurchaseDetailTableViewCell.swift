import Apollo
import UI

final class PurchaseDetailTableViewCell: UITableViewCell, ViewConfiguration {
    // MARK: - Properties
    private var model: PurchaseProductModel?

    // MARK: - View
    private lazy var titleText: Text = {
        let view = Text()
        view.font(Font.note)
        view.foreground(color: .grayScale800)
        return view
    }()

    private lazy var detailText: Text = {
        let view = Text()
        view.font(Font.body.highlighted)
        view.foreground(color: .grayScale900)
        return view
    }()

    private lazy var lineView: UIView = {
        let view = UIView()
        view.background(color: .grayScale200)
        return view
    }()

    private lazy var documentIcon = UIImageView()

    private lazy var documentTitle: Text = {
        let view = Text()
        view.font(Font.note)
        view.foreground(color: .grayScale800)
        return view
    }()

    private lazy var arrowView = UIImageView(image: Icon.angleRightB.image)

    private lazy var documentCell: UIStackView = {
        let stack = UIStackView()
        stack.spacing = Space.base02.rawValue
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: Space.base02.rawValue, left: 0, bottom: Space.base02.rawValue, right: 0)
        stack.addArrangedSubview(documentIcon)
        stack.addArrangedSubview(documentTitle)
        stack.addArrangedSubview(arrowView)
        return stack
    }()

    // MARK: - Override
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewConfiguration
    func buildViewHierarchy() {
        addSubview(titleText)
        addSubview(detailText)
        addSubview(lineView)
        addSubview(documentCell)
    }

    func setupConstraints() {
        titleText.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Space.base04.rawValue)
            $0.leading.trailing.equalToSuperview().inset(Space.base04.rawValue)
        }
        detailText.snp.makeConstraints {
            $0.top.equalTo(titleText.snp.bottom).offset(Space.base02.rawValue)
            $0.leading.trailing.equalToSuperview().inset(Space.base04.rawValue)
            $0.bottom.equalToSuperview().inset(Space.base04.rawValue)
        }
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        documentCell.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Space.base04.rawValue)
        }

        documentIcon.snp.makeConstraints {
            $0.width.equalTo(Space.base04.rawValue)
        }

        arrowView.snp.makeConstraints {
            $0.size.equalTo(Space.base04.rawValue)
        }
    }

    func configureViews() {
        selectionStyle = .none
        backgroundColor = .clear
    }

    // MARK: - Public
    func setup(with model: PurchaseDetailDTO.Field) {
        documentCell.isHidden = true
        if let title = model.label {
            titleText.hidden(false)
            titleText.value = title.value
            titleText.setTypograph(title.typograph)
        }
        if let detail = model.value {
            detailText.hidden(false)
            detailText.value = detail.value
            detailText.setTypograph(detail.typograph)
        }
    }

    func setup(with model: PurchaseDetailDTO.DocumentItem) {
        titleText.hidden(true)
        detailText.hidden(true)
        titleText.value = ""
        detailText.value = ""
        documentCell.isHidden = false
        documentTitle.value = model.name
        documentIcon.image = (Icon(rawValue: model.imageIcon) ?? Icon.documentInfo).image
    }
}
