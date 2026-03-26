import UIKit

protocol PurchaseListPresenting: AnyObject {
    func present(model: [PurchaseProductModel])
    func didNextStep(action: PurchaseListAction)
    func presentDetailForItem(index: Int)
    func startLoading()
    func stopLoading()
    func presentError(_ error: ApiError)
}

final class PurchaseListPresenter {
    typealias Localizable = Strings.Purchase.List
    // MARK: - Properties
    typealias Dependencies = HasNoDependency
    private let dependencies: Dependencies

    private let coordinator: PurchaseListCoordinating
    weak var viewController: PurchaseListDisplaying?

    private var dto: PurchaseListDTO?
    private var model: [PurchaseProductModel]?

    // MARK: - Initialize
    init(coordinator: PurchaseListCoordinating, dependencies: Dependencies) {
        self.coordinator = coordinator
        self.dependencies = dependencies
    }

    // MARK: - Private
    private func createDTO(with model: [PurchaseProductModel]) -> PurchaseListDTO {
        let cards = model.map { data in
            let title = PurchaseListDTO.Field(label: .init(stringToken: data.name), value: nil)
            let metadados = data.information.metadatas.map { metadata in
                PurchaseListDTO.Field(
                    label: StringWithTypograph(stringToken: metadata.label),
                    value: StringWithTypograph(
                        value: metadata.value?.value ?? "",
                        typograph: metadata.value?.style ?? ""
                    )
                )
            }
            var fields = [PurchaseListDTO.Field]()
            fields.append(title)
            fields.append(contentsOf: metadados)
            return PurchaseListDTO.Card(fields: fields)
        }

        var title = model.first?.productType.name.value
        var titleTypograph = model.first?.productType.name.style
        if model.first?.productType.id == 0 {
            title = model.first?.product.name.value
            titleTypograph = model.first?.product.name.style
        }

        return .init(
            title: StringWithTypograph(
                value: title ?? "",
                typograph: titleTypograph ?? ""
            ),
            detail: StringWithTypograph(
                value: model.first?.productType.description?.value ?? "",
                typograph: model.first?.productType.description?.style ?? ""
            ),
            headerTitle: StringWithTypograph(value: Localizable.headerTitle, typograph: "header3"),
            cards: cards
        )
    }
}

// MARK: - PurchaseListPresenting
extension PurchaseListPresenter: PurchaseListPresenting {
    func presentDetailForItem(index: Int) {
        guard
            let modelArray = model,
            index < modelArray.count else {
                print("❌ Invalid index \(index) for model count \(model?.count ?? 0)")
                return
            }
        
        let selectedModel = modelArray[index]
        let id = selectedModel.id
        let typeId = selectedModel.product.id
        let productTypeId = selectedModel.productType.id
        
        print("📋 List Item Selected:")
        print("   Index: \(index)")
        print("   Offer ID: \(id)")
        print("   Product ID: \(typeId)")
        print("   ProductType ID: \(productTypeId)")
        print("   ProductType Name: \(selectedModel.productType.name.value)")
        
        coordinator.perform(
            action: .detail(
                offerId: String(id),
                productId: String(typeId),
                productTypeId: String(productTypeId)
            )
        )
    }

    func present(model: [PurchaseProductModel]) {
        self.model = model
        dto = createDTO(with: model)
        guard let dto = dto else { return }
        viewController?.display(dto: dto)
    }

    func didNextStep(action: PurchaseListAction) {
        coordinator.perform(action: action)
    }

    func startLoading() {
        viewController?.starLoading()
    }

    func stopLoading() {
        viewController?.stopLoading()
    }

    func presentError(_ error: ApiError) {
        viewController?.displayFeedback(feedback: error.feedback)
    }
}
