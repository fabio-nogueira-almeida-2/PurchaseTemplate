struct PurchaseProductModel: Decodable, Equatable {
    let id: Int
    let name: StringToken
    let description: StringToken?
    let imageIcon: String?
    let status: Status
    let product: Product
    let productType: ProductType
    let information: Information
    let externalCode: String
    let assetSymbol: String
    let documents: [Document]?

    struct Product: Decodable, Equatable {
        let id: Int
        let name: StringToken
        let description: StringToken?
    }

    struct ProductType: Decodable, Equatable {
        let id: Int
        let name: StringToken
        let description: StringToken?
    }

    struct Information: Decodable, Equatable {
        let metadatas: [MetaData]
        let groups: [Group]?
    }

    struct MetaData: Decodable, Equatable {
        let id: Int
        let label: StringToken
        let description: StringToken?
        let value: StringToken?
        let externalCode: String
    }

    struct Group: Decodable, Equatable {
        let id: Int
        let name: StringToken
        let description: StringToken?
        let metadatas: [MetaData]?
        let groups: [Group]?
    }

    struct Document: Decodable, Equatable {
        let id: Int
        let offerId: Int
        let name: String
        let description: String
        let imageIcon: String
        let url: String
    }

    struct Status: Decodable, Equatable {
        let id: Int
        let name: String
    }
}
