//
//  PurchaseInputValueFixture.swift
//  PurchaseTemplate
//
//  Mock fixture data for Purchase Input Value screen
//

import Foundation

struct PurchaseInputValueFixture {
    static func mockResponse(productId: String, offerId: String) -> PurchaseInputValueService.Response {
        return PurchaseInputValueService.Response(
            data: PurchaseOrderRuleModel(
                balance: nil,
                balanceOrigin: "wallet",
                balances: PurchaseOrderRuleModel.Balances(
                    wallet: 5000.0,
                    invest: 2000.0
                ),
                rules: PurchaseOrderRuleModel.Rules(
                    value: PurchaseOrderRuleModel.ValueRules(
                        min: 100,
                        max: 10000,
                        multiple: 100
                    )
                )
            )
        )
    }
}


