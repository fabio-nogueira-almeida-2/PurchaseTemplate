extension InvestmentsEndpoint {
    static func purchaseWelcome(productId: String, productTypeId: String) -> Self {
        .init(path: "picpay-invest/investplace/v1/products/\(productId)/type/\(productTypeId)/welcome")
    }

    static func purchaseOrders(productId: String) -> Self {
        .init(path: "picpay-invest/investplace/v1/products/\(productId)/orders")
    }

    static func purchaseOrderDetail(productId: String, offerId: String) -> Self {
        .init(path: "picpay-invest/investplace/v1/products/\(productId)/orders/\(offerId)")
    }

    static func purchaseCustody(productId: String) -> Self {
        .init(path: "picpay-invest/investplace/v1/products/\(productId)/custody")
    }

    static func purchaseCustodyDetail(productId: String, offerId: String) -> Self {
        .init(path: "picpay-invest/investplace/v1/products/\(productId)/custody/\(offerId)")
    }

    static func purchaseCustodyPosition(productId: String) -> Self {
        .init(path: "picpay-invest/investplace/v1/products/\(productId)/total")
    }

    static func purchaseOffers(productId: String, productTypeId: String) -> Self {
        .init(path: "picpay-invest/investplace/v1/products/\(productId)/offers")
    }

    static func purchaseOfferDetail(productId: String, offerId: String) -> Self {
        .init(path: "picpay-invest/investplace/v1/products/\(productId)/offers/\(offerId)")
    }

    static func purchaseOrderRule(productId: String, offerId: String) -> Self {
        .init(path: "picpay-invest/investplace/v1/products/\(productId)/offers/\(offerId)/rules")
    }

    static func purchaseOrder(
        consumerId: String,
        productId: String,
        offerId: String,
        model: PurchaseOrderRequest
    ) -> Self {
        let body = try? JSONEncoder().encode(model)
        return .init(
            path: "picpay-invest/investplace/v1/products/\(productId)/orders/offers/\(offerId)/buy",
            method: .post,
            body: body,
            customHeaders: ["consumer_id": consumerId]
        )
    }
}
