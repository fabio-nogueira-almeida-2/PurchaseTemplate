import Apollo
import UI

final class PurchaseListHeaderView: UIStackView, ViewConfiguration {
    // MARK: - View
    lazy var titleText = Text()

    lazy var descriptionText = Text()

    lazy var searchField: SearchField = {
        let view = SearchField()
        view.delegate = self
        return view
    }()

    lazy var filterIcon: Apollo.IconButton = {
        let view = IconButton(style: .disabled)
        view.icon(.filter)
        view.size(.small)
        view.action = {[weak self] in
         }
        return view
    }()

    lazy var chipsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = Space.base02.rawValue
        view.distribution = .fillProportionally
        return view
    }()

    private lazy var chipsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(chipsStackView)
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    lazy var firstChips: Chips = {
      Chips(isToogle: true)
          .text("Em alta")
          .action { _ in
          }
    }()

    lazy var secondChips: Chips = {
      Chips(isToogle: true)
          .text("Menor valor")
          .action { _ in
          }
    }()

    lazy var thirdChips: Chips = {
      Chips(isToogle: true)
          .text("Maior rentabilidade")
          .action { _ in
          }
    }()

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewConfiguration
    func buildViewHierarchy() {
        addArrangedSubview(descriptionText)
        addArrangedSubview(titleText)
    }

    func setupConstraints() {
        titleText.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
    }

    func configureViews() {
        axis = .vertical
        spacing = Space.base04.rawValue
        distribution = .fillProportionally
        compatibleLayoutMargins = EdgeInsets(top: EdgeInsets.rootView.top,
                                             leading: EdgeInsets.rootView.leading,
                                             bottom: Space.base00.rawValue,
                                             trailing: EdgeInsets.rootView.trailing)
        isLayoutMarginsRelativeArrangement = true
        background(color: .white)
    }

    func configureStyles() {
    }

    func setup(title: StringWithTypograph, description: StringWithTypograph) {
        titleText.value = title.value
        titleText.setTypograph(title.typograph)
        descriptionText.value = description.value
        descriptionText.setTypograph(description.typograph)
    }
}

// MARK: - SearchFieldDelegate
extension PurchaseListHeaderView: SearchFieldDelegate {
    func didBeginEditing(autofocused: Bool) {
    }

    func didChangeText(_ newText: String?, previousText: String?) {
    }

    func didCancel() {
    }
}
