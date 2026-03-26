import UIKit

protocol PurchaseInputValuePresenting: InsertValueTransferPresenting {
    func confirmTransactionScreen(model: PurchaseOrderModel)
    func show(rules: PurchaseOrderRuleModel, isProgressBarVisible: Bool)
    func valueUnderMinimun(minimum: Double)
    func startLoading()
    func stopLoading()
}

final class PurchaseInputValuePresenter {
    typealias Localizable = Strings.BalanceTransfer.InsertValueTransfer

    private let coordinator: PurchaseInputValueCoordinating
    weak var viewController: InsertValueTransferDisplaying?

    init(coordinator: PurchaseInputValueCoordinating) {
        self.coordinator = coordinator
    }
}

// MARK: - PurchaseInputValuePresenting
extension PurchaseInputValuePresenter: PurchaseInputValuePresenting {
    func show(balance: Double, isProgressBarVisible: Bool) {
        // implementar no futuro
    }

    func confirmTransactionScreen(model: PurchaseOrderModel) {
        coordinator.openConfirmTransaction(model: model)
    }

    func show(rules: PurchaseOrderRuleModel, isProgressBarVisible: Bool = true) {
        guard let amountFormatted = getBalance(rules: rules).toCurrencyString() else { return }
        let chips = createChips(with: rules)
        let viewModel = InsertValueTransferViewModel(
            title: Strings.Purchase.Input.title,
            description: Localizable.walletValue(amountFormatted),
            amountFormatted: amountFormatted,
            chips: chips,
            isProgressVisible: isProgressBarVisible
        )
        viewController?.display(viewModel: viewModel)
    }

    func noBalanceInserted() {
        viewController?.displayError(message: Localizable.missingValue)
    }

    func balanceExceeded(maxBalance: Double) {
        guard let amountFormatted = maxBalance.toCurrencyString() else { return }
        viewController?.displayError(message: Localizable.valueExceeded(amountFormatted))
    }

    func confirmTransactionScreen(amount: Double) {
//        coordinator.openConfirmTransaction(model: .init(amount: amount, type: type, showProgressBar: true))
    }

    func valueUnderMinimun(minimum: Double) {
        guard let minimumFormatted = minimum.toCurrencyString() else { return }
        viewController?.displayError(message: Localizable.underMinValue(minimumFormatted))
    }

    func startLoading() {
        viewController?.startLoading()
    }

    func stopLoading() {
        viewController?.stopLoading()
    }
}

private extension PurchaseInputValuePresenter {
    func createChips(with rules: PurchaseOrderRuleModel) -> [InsertValueTransferViewModel.Chip] {
        var chips: [InsertValueTransferViewModel.Chip] = [
            .init(label: Localizable.allValue, value: getBalance(rules: rules), operation: .equal)
        ]
        if let values = rules.rules.value {
            let min = Double(values.min)
            let mult = Double(values.multiple)
            let chipsValues: [Double] = [min, min * mult, min * mult * 2]
            chips.append(contentsOf: chipsValues.compactMap {
                guard let amountFormatted = $0.toCurrencyString(maxFractionDigits: 0) else { return nil }
                return .init(
                    label: Localizable.addValue(amountFormatted),
                    value: $0,
                    operation: .add,
                    analyticsText: amountFormatted.replacingCurrencySpaceWithUnderscore().removeDot()
                )
            })
        }

        return chips
    }

    func getBalance(rules: PurchaseOrderRuleModel) -> Double {
        var balance = rules.balance
        if balance == nil {
            if rules.balanceOrigin == "wallet" {
                balance = rules.balances.wallet
            } else {
                balance = rules.balances.invest
            }
        }

        return balance ?? 0.0
    }
}
