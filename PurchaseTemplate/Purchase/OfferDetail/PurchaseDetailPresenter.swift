import UIKit

protocol PurchaseDetailPresenting: AnyObject {
    func present(model: PurchaseProductModel)
    func presentInputValueScreen(model: PurchaseOrderModel)
    func startLoading()
    func stopLoading()
    func presentError(_ error: ApiError)
    func presentDocument(url: URL)
}

final class PurchaseDetailPresenter {
    // MARK: - Properties
    typealias Dependencies = HasNoDependency
    private let dependencies: Dependencies

    private let coordinator: PurchaseDetailCoordinating
    weak var viewController: PurchaseDetailDisplaying?

    // MARK: - Initialize
    init(coordinator: PurchaseDetailCoordinating, dependencies: Dependencies) {
        self.coordinator = coordinator
        self.dependencies = dependencies
    }

    // MARK: - Private
    private func generateMetadataFields(on metadata: [PurchaseProductModel.MetaData]) -> [PurchaseDetailDTO.Field] {
        let fieldsMetadata: [PurchaseDetailDTO.Field] = metadata.map { metadata in
            PurchaseDetailDTO.Field(
                label: StringWithTypograph(stringToken: metadata.label),
                value: StringWithTypograph(value: metadata.value?.value ?? "", typograph: metadata.value?.style ?? "")
            )
        }
        return fieldsMetadata
    }

    private func generateGroupMetadataFields(_ group: PurchaseProductModel.Group) -> [PurchaseDetailDTO.Section] {
        var sections = [PurchaseDetailDTO.Section]()
        if let metadataSection = group.metadatas.map({ metadata in
            PurchaseDetailDTO.Section(title: group.name.value, rows: generateMetadataFields(on: metadata))
        }) {
            sections.append(metadataSection)
        }
        _ = group.groups.map { result in
            result.map { result in
                let groupMetadataSection = generateGroupMetadataFields(result)
                sections.append(contentsOf: groupMetadataSection)
            }
        }
        return sections
    }

    private func generateSections(with data: PurchaseProductModel) -> [PurchaseDetailDTO.Section] {
        var sections = [PurchaseDetailDTO.Section]()
        if !data.information.metadatas.isEmpty {
            let metadataSection = PurchaseDetailDTO.Section(
                title: nil,
                rows: generateMetadataFields(on: data.information.metadatas)
            )
            sections.append(metadataSection)
        }

        data.information.groups?.forEach { group in
            sections.append(contentsOf: generateGroupMetadataFields(group))
        }
        return sections
    }

    private func generateDocument(with data: PurchaseProductModel) -> [PurchaseDetailDTO.DocumentItem] {
        guard let documentsDTO = data.documents else { return [] }
        var documents: [PurchaseDetailDTO.DocumentItem] = []
        documentsDTO.forEach { document in
            documents.append(.init(imageIcon: document.imageIcon, name: document.name, url: document.url))
        }
        return documents
    }

    private func createDTO(with model: PurchaseProductModel) -> PurchaseDetailDTO {
        var sections = [PurchaseDetailDTO.Section]()
        sections.append(contentsOf: generateSections(with: model))
        return PurchaseDetailDTO(
            title: StringWithTypograph(stringToken: model.productType.name),
            detail: StringWithTypograph(
                value: model.description?.value ?? "",
                typograph: model.description?.style ?? ""
            ),
            productType: model.productType.name.value,
            sections: sections,
            documents: generateDocument(with: model)
        )
    }
}

// MARK: - PurchaseDetailPresenting
extension PurchaseDetailPresenter: PurchaseDetailPresenting {
    func present(model: PurchaseProductModel) {
        let dto = createDTO(with: model)
        viewController?.display(dto: dto)
    }

    func presentInputValueScreen(model: PurchaseOrderModel) {
        coordinator.showInputValueScreen(model: model)
    }

    func startLoading() {
        viewController?.startLoading()
    }

    func stopLoading() {
        viewController?.stopLoading()
    }

    func presentError(_ error: ApiError) {
        viewController?.displayFeedback(feedback: error.feedback)
    }

    func presentDocument(url: URL) {
        coordinator.openDocument(url: url)
    }
}
