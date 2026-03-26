import CoreTrackingInterface

struct PurchaseOrderModel: Equatable {
    var offerId: String
    var productId: String
    var value: Double
    var quantity: Int
    let tokenValue: Int
    let typeName: String
    let productName: String
}

final class PurchaseInputValueInteractor {
    private var orderModel: PurchaseOrderModel
    private var maxBalance: Double?
    private let presenter: PurchaseInputValuePresenting
    private let service: PurchaseInputValueServicing
    private var validationRules: PurchaseOrderRuleModel?

    init(
        service: PurchaseInputValueServicing,
        presenter: PurchaseInputValuePresenting,
        orderModel: PurchaseOrderModel
    ) {
        self.service = service
        self.presenter = presenter
        self.orderModel = orderModel
    }
}

// MARK: - InsertValueTransferInteracting
extension PurchaseInputValueInteractor: InsertValueTransferInteracting {
    func load() {
        presenter.startLoading()
        service.getData(
            productId: orderModel.productId,
            offerId: orderModel.offerId
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                self.validationRules = response.data
                presenter.show(rules: response.data, isProgressBarVisible: false)
            case .failure:
                break
            }
            presenter.stopLoading()
        }
    }

    func didTapContinueButton(amount: Double) {
        guard let rules = validationRules else {
            return
        }
        guard amount > 0 else {
            return presenter.noBalanceInserted()
        }
        let balance = getBalance()
        guard amount <= balance else {
            return presenter.balanceExceeded(maxBalance: balance)
        }
        if let minValue = rules.rules.value?.min, amount < Double(minValue) {
            return presenter.valueUnderMinimun(minimum: Double(minValue))
        }
        if let maxValue = rules.rules.value?.max, amount > Double(maxValue) {
            return presenter.balanceExceeded(maxBalance: Double(maxValue))
        }
        orderModel.value = amount
        presenter.confirmTransactionScreen(model: orderModel)
    }
}

// MARK: - private
private extension PurchaseInputValueInteractor {
    func getBalance() -> Double {
        guard let rules = validationRules else {
            return 0.0
        }

        var balance = rules.balance
        if balance == nil {
            if rules.balanceOrigin == "picpay" {
                balance = rules.balances.picpay
            } else {
                balance = rules.balances.picpayInvest
            }
        }

        return balance ?? 0.0
    }
}
