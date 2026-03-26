import UIKit

protocol PurchaseCatalogDisplaying: PurchaseCustodyDisplaying {
    // Inherits all methods from PurchaseCustodyDisplaying:
    // func display(dto: PurchaseCustodyDTO)
    // func starLoading()
    // func stopLoading()
    // func displayFeedback(feedback: InvestmentsHubFeedback)
}

protocol PurchaseCatalogPresenting: AnyObject {
    func present(model: [PurchaseProductModel])
    func didNextStep(action: PurchaseCatalogAction)
    func presentDetailForItem(index: Int)
    func startLoading()
    func stopLoading()
    func presentError(_ error: ApiError)
}

// Make PurchaseCatalogPresenter compatible with PurchaseCustodyPresenting
extension PurchaseCatalogPresenter: PurchaseCustodyPresenting {}

enum PurchaseCatalogAction: Equatable {
    case detail(offerId: String, productId: String, productTypeId: String)
}

final class PurchaseCatalogPresenter {
    typealias Localizable = Strings.Purchase.List
    // MARK: - Properties
    typealias Dependencies = HasNoDependency
    private let dependencies: Dependencies

    private let coordinator: PurchaseCatalogCoordinating
    weak var viewController: PurchaseCatalogDisplaying?
    // Also keep a reference to PurchaseCustodyDisplaying for direct access
    weak var custodyViewController: PurchaseCustodyDisplaying?

    private var dto: PurchaseCustodyDTO?
    private var model: [PurchaseProductModel]?

    // MARK: - Initialize
    init(coordinator: PurchaseCatalogCoordinating, dependencies: Dependencies) {
        self.coordinator = coordinator
        self.dependencies = dependencies
    }

    // MARK: - Private
    private func createDefaultPosition() -> PurchaseCustodyService.PositionResponse.TotalPositionValue {
        // Create a default position for catalog (since we don't have a specific productId)
        return PurchaseCustodyService.PositionResponse.TotalPositionValue(
            value: PurchaseCustodyService.PositionResponse.TotalPositionValue.Token(
                label: StringToken(value: "Total", style: "body1"),
                description: nil,
                value: StringToken(value: "0", style: "header3")
            ),
            yield: PurchaseCustodyService.PositionResponse.TotalPositionValue.Token(
                label: StringToken(value: "Rendimento", style: "body1"),
                description: nil,
                value: StringToken(value: "0%", style: "header3")
            )
        )
    }
    
    private func createDTO(
        with model: [PurchaseProductModel],
        position: PurchaseCustodyService.PositionResponse.TotalPositionValue,
        isCustodyFilter: Bool = false
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
        
        // For catalog, use a generic title
        let title = "Catálogo de Investimentos"
        
        let header = PurchaseCustodyDTO.Header(
            left: .init(
                label: StringWithTypograph(stringToken: position.value.label),
                value: StringWithTypograph(stringToken: position.value.value ?? StringToken(value: "0", style: "body1"))
            ),
            right: .init(
                label: StringWithTypograph(stringToken: position.yield.label),
                value: StringWithTypograph(stringToken: position.yield.value ?? StringToken(value: "0%", style: "body1"))
            )
        )
        
        let detail = StringWithTypograph(
            value: "Explore todas as oportunidades de investimento disponíveis",
            typograph: "body1"
        )
        
        return .init(title: title, header: header, detail: detail, cards: cards)
    }
}

// MARK: - PurchaseCatalogPresenting
extension PurchaseCatalogPresenter: PurchaseCatalogPresenting {
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
        
        print("📋 Catalog Item Selected:")
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
        print("📋 PurchaseCatalogPresenter.present() called with \(model.count) items")
        self.model = model
        let position = createDefaultPosition()
        dto = createDTO(with: model, position: position)
        guard let dto = dto else {
            print("❌ PurchaseCatalogPresenter: DTO is nil!")
            return
        }
        print("📋 PurchaseCatalogPresenter: Created DTO with \(dto.cards.count) cards")
        print("📋 PurchaseCatalogPresenter: viewController is \(viewController != nil ? "set" : "nil")")
        print("📋 PurchaseCatalogPresenter: custodyViewController is \(custodyViewController != nil ? "set" : "nil")")
        
        // Try PurchaseCatalogDisplaying first, then fallback to PurchaseCustodyDisplaying
        if let catalogDisplaying = viewController {
            print("📋 Calling display via PurchaseCatalogDisplaying")
            catalogDisplaying.display(dto: dto)
        } else if let custodyDisplaying = custodyViewController {
            print("📋 Calling display via PurchaseCustodyDisplaying (fallback)")
            custodyDisplaying.display(dto: dto)
        } else {
            print("❌ PurchaseCatalogPresenter: viewController is nil! Cannot display DTO.")
        }
    }

    func didNextStep(action: PurchaseCatalogAction) {
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

// MARK: - PurchaseCustodyPresenting
extension PurchaseCatalogPresenter {
    func present(order: [PurchaseProductModel], position: PurchaseCustodyService.PositionResponse.TotalPositionValue) {
        present(model: order, position: position)
    }
    
    func present(custody: [PurchaseProductModel], position: PurchaseCustodyService.PositionResponse.TotalPositionValue) {
        present(model: custody, position: position)
    }
    
    func presentCatalog(id: String) {
        // For catalog, navigate to dashboard when invest button is tapped
        coordinator.navigateToDashboard()
    }
    
    func presentFAQ() {
        // Handle FAQ navigation if needed
    }
    
    private func present(model: [PurchaseProductModel], position: PurchaseCustodyService.PositionResponse.TotalPositionValue) {
        self.model = model
        dto = createDTO(with: model, position: position)
        guard let dto = dto else { return }
        viewController?.display(dto: dto)
    }
}

