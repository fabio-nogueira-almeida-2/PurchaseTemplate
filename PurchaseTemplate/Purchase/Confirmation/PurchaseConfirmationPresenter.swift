import Core

protocol PurchaseConfirmationPresenting: AnyObject {
    func display(_ model: PurchaseOrderModel)
    func didNextStep(action: PurchaseConfirmationAction)
    func startLoading()
    func stopLoading()
    func presentError(_ error: ApiError)
}

final class PurchaseConfirmationPresenter {
    typealias Dependencies = HasNoDependency
    private let dependencies: Dependencies

    private let coordinator: PurchaseConfirmationCoordinating
    weak var viewController: PurchaseConfirmationDisplaying?

    private let strings = Strings.Purchase.Confirmation.self

    init(coordinator: PurchaseConfirmationCoordinating, dependencies: Dependencies) {
        self.coordinator = coordinator
        self.dependencies = dependencies
    }

    func setupDTO(with model: PurchaseOrderModel) -> PurchaseConfirmationDTO {
        let originalValue = PurchaseConfirmationDTO.Field(
            label: StringWithTypograph(value: strings.originalValue, typograph: ""),
            value: StringWithTypograph(value: model.value.toCurrencyString() ?? "", typograph: "body2")
        )
        let quantity = PurchaseConfirmationDTO.Field(
            label: StringWithTypograph(value: strings.quantity, typograph: ""),
            value: StringWithTypograph(value: String(model.quantity), typograph: "body2")
        )
        let value = PurchaseConfirmationDTO.Field(
            label: StringWithTypograph(value: strings.value, typograph: ""),
            value: StringWithTypograph(value: model.tokenValue.toCurrencyString() ?? "", typograph: "body2")
        )
        let type = PurchaseConfirmationDTO.Field(
            label: StringWithTypograph(value: strings.type, typograph: ""),
            value: StringWithTypograph(value: model.typeName, typograph: "body2")
        )
        let product = PurchaseConfirmationDTO.Field(
            label: StringWithTypograph(value: strings.product, typograph: ""),
            value: StringWithTypograph(value: model.productName, typograph: "body2")
        )
        return PurchaseConfirmationDTO(
            title: StringWithTypograph(value: strings.title, typograph: "header2"),
            button: strings.button,
            fields: [originalValue, type, product]
        )
    }
}

// MARK: - RoyaltyConfirmationPresenting
extension PurchaseConfirmationPresenter: PurchaseConfirmationPresenting {
    func display(_ model: PurchaseOrderModel) {
        let dto = setupDTO(with: model)
        viewController?.display(dto: dto)
    }

    func didNextStep(action: PurchaseConfirmationAction) {
        coordinator.perform(action: action)
    }

    func startLoading() {
        viewController?.startLoading(viewModel: .init(illustration: .moneyWalletCoins,
                                                      text: strings.loading,
                                                      loadingTimeInSeconds: 5))
    }

    func stopLoading() {
        viewController?.stopLoading()
    }

    func presentError(_ error: ApiError) {
        viewController?.displayFeedback(feedback: error.feedback)
    }
}
