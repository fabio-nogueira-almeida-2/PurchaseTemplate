import Foundation

protocol PurchaseCustodyPresenting: AnyObject {
    func present(order: [PurchaseProductModel], position: PurchaseCustodyService.PositionResponse.TotalPositionValue)
    func present(custody: [PurchaseProductModel], position: PurchaseCustodyService.PositionResponse.TotalPositionValue)
    func startLoading()
    func stopLoading()
    func presentError(_ error: ApiError)
    func presentCatalog(id: String)
    func presentDetailForItem(index: Int)
    func presentFAQ()
}

final class PurchaseCustodyPresenter {
    // MARK: - Properties
//    private let coordinator: PurchaseCustodyCoordinating
    weak var viewController: PurchaseCustodyDisplaying?
    
    private var dto: PurchaseCustodyDTO?
    private var model: [PurchaseProductModel]?
    
    // MARK: - Initialize
//    init(coordinator: PurchaseCustodyCoordinating) {
//        self.coordinator = coordinator
//    }
    
    // MARK: - Private
    private func createDTO(
        with model: [PurchaseProductModel],
        position: PurchaseCustodyService.PositionResponse.TotalPositionValue,
        isCustodyFilter: Bool
    ) -> PurchaseCustodyDTO {
        let cards = model.map { data in
            let fields: [PurchaseCustodyDTO.Field] = data.information.metadatas.map { metadata in
                PurchaseCustodyDTO.Field(
                    label: StringWithTypograph(stringToken: metadata.label),
                    value: StringWithTypograph(
                        value: metadata.value?.value ?? "",
                        typograph: metadata.value?.style ?? ""
                    )
                )
            }
            return PurchaseCustodyDTO.Card(
                title: StringWithTypograph(stringToken: data.name),
                fields: fields
            )
        }
        var title = model.first?.productType.name.value
        if model.first?.productType.id == 0 {
            title = model.first?.product.name.value
        }
        
        let header =
        PurchaseCustodyDTO.Header(
            left: .init(
                label: StringWithTypograph(stringToken: position.value.label),
                value: StringWithTypograph(stringToken: position.value.value!)
            ),
            right: .init(
                label: StringWithTypograph(stringToken: position.yield.label),
                value: StringWithTypograph(stringToken: position.yield.value!)
            )
        )
        let detail = StringWithTypograph(
            value: model.first?.productType.description?.value ?? "",
            typograph: model.first?.productType.description?.style ?? ""
        )
        return .init(title: title ?? "", header: header, detail: detail, cards: cards)
    }
    
    func present(
        model: [PurchaseProductModel],
        position: PurchaseCustodyService.PositionResponse.TotalPositionValue,
        isCustodyFilter: Bool = false) {
        self.model = model
        self.dto = createDTO(with: model, position: position, isCustodyFilter: isCustodyFilter)
        guard let dto = self.dto else { return }
        viewController?.display(dto: dto)
    }
}

// MARK: - PurchaseCustodyPresenting
extension PurchaseCustodyPresenter: PurchaseCustodyPresenting {
    func startLoading() {
        viewController?.starLoading()
    }
    
    func stopLoading() {
        viewController?.stopLoading()
    }
    
    func present(order: [PurchaseProductModel], position: PurchaseCustodyService.PositionResponse.TotalPositionValue) {
        present(model: order, position: position)
    }
    
    func present(custody: [PurchaseProductModel], position: PurchaseCustodyService.PositionResponse.TotalPositionValue) {
        present(model: custody, position: position)
    }
    
    func presentError(_ error: ApiError) {
        viewController?.displayFeedback(feedback: error.feedback)
    }
    
    func presentCatalog(id: String) {
//        coordinator.navigateToCatalog(id: id)
    }
    
    func presentDetailForItem(index: Int) {
        guard
            let id = model?[index].id,
            let typeId = model?[index].product.id
        else {
            return
        }
//        coordinator.navigateToCustodyDetail(productId: String(typeId), offerId: String(id))
    }
    
    func presentFAQ() {
//        coordinator.navigateToFAQ()
    }
}

// MARK: - DTO
struct PurchaseCustodyDTO {
    let title: String
    let header: Header
    let detail: StringWithTypograph?
    let cards: [Card]
    
    struct Card {
        let title: StringWithTypograph
        let fields: [Field]
    }
    
    struct Header {
        let left: Field?
        let right: Field?
    }
    
    struct Field: Equatable {
        let label: StringWithTypograph?
        let value: StringWithTypograph?
    }
}

