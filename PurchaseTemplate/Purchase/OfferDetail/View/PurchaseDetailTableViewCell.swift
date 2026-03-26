import UIKit

final class PurchaseDetailTableViewCell: UITableViewCell, ViewConfiguration {
    static let identifier = "PurchaseDetailTableViewCell"
    
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
        view.font(Font.body)
        view.foreground(color: .grayScale900)
        return view
    }()

    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.grayScale200.uiColor
        return view
    }()

    private lazy var documentIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var documentTitle: Text = {
        let view = Text()
        view.font(Font.note)
        view.foreground(color: .grayScale800)
        return view
    }()

    private lazy var arrowView: UIImageView = {
        let view = UIImageView()
        if let icon = Icon(rawValue: "angle.right.b") {
            view.image = icon.image
        }
        view.contentMode = .scaleAspectFit
        return view
    }()

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
            $0.leading.equalToSuperview().inset(Space.base04.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base04.rawValue)
        }
        detailText.snp.makeConstraints {
            $0.top.equalTo(titleText.snp.bottom).offset(Space.base02.rawValue)
            $0.leading.equalToSuperview().inset(Space.base04.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base04.rawValue)
            $0.bottom.equalToSuperview().inset(Space.base04.rawValue)
        }
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        documentCell.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(Space.base04.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base04.rawValue)
        }

        documentIcon.snp.makeConstraints {
            $0.width.equalTo(Space.base04.rawValue)
        }

        arrowView.snp.makeConstraints {
            $0.width.equalTo(Space.base04.rawValue)
            $0.height.equalTo(Space.base04.rawValue)
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
            titleText.isHidden = false
            titleText.value = title.value
            titleText.setTypograph(title.typograph.rawValue)
        }
        if let detail = model.value {
            detailText.isHidden = false
            detailText.value = detail.value
            detailText.setTypograph(detail.typograph.rawValue)
        }
    }

    func setup(with model: PurchaseDetailDTO.DocumentItem) {
        titleText.isHidden = true
        detailText.isHidden = true
        titleText.value = ""
        detailText.value = ""
        documentCell.isHidden = false
        documentTitle.value = model.name
        if let icon = Icon(rawValue: model.imageIcon) {
            documentIcon.image = icon.image
        }
    }
}
