//
//  PurchaseDetailFixture.swift
//  PurchaseTemplate
//
//  Mock fixture data for Purchase Detail screen
//

import Foundation

struct PurchaseDetailFixture {
    static func mockResponse(productId: String, offerId: String, productTypeId: String? = nil) -> PurchaseDetailService.Response {
        let offerIdInt = Int(offerId) ?? 1
        let productIdInt = Int(productId) ?? 1
        let productTypeIdInt = Int(productTypeId ?? "1") ?? 1
        let isRoyalties = productTypeIdInt == 2
        
        if isRoyalties {
            // Royalties Investment detail data
            return PurchaseDetailService.Response(
                data: PurchaseProductModel(
                    id: offerIdInt,
                    name: StringToken(value: "Royalties Música Pop", style: "header4"),
                    description: StringToken(value: "Receba rendimentos mensais de royalties musicais de forma segura e previsível", style: "body1"),
                    imageIcon: "music.note",
                    status: PurchaseProductModel.Status(id: 1, name: "Ativo"),
                    product: PurchaseProductModel.Product(
                        id: productIdInt,
                        name: StringToken(value: "Royalties Musicais", style: "header3"),
                        description: StringToken(value: "Invista em royalties de música", style: "body1")
                    ),
                    productType: PurchaseProductModel.ProductType(
                        id: productTypeIdInt,
                        name: StringToken(value: "Royalties", style: "header3"),
                        description: StringToken(value: "Receba rendimentos mensais previsíveis", style: "body1")
                    ),
                    information: PurchaseProductModel.Information(
                        metadatas: [
                            PurchaseProductModel.MetaData(
                                id: 1,
                                label: StringToken(value: "Rendimento Mensal", style: "body2"),
                                description: nil,
                                value: StringToken(value: "1,2% a.m.", style: "body1"),
                                externalCode: "monthly_yield"
                            ),
                            PurchaseProductModel.MetaData(
                                id: 2,
                                label: StringToken(value: "Valor Mínimo", style: "body2"),
                                description: nil,
                                value: StringToken(value: "R$ 500,00", style: "body1"),
                                externalCode: "min_value"
                            ),
                            PurchaseProductModel.MetaData(
                                id: 3,
                                label: StringToken(value: "Prazo", style: "body2"),
                                description: nil,
                                value: StringToken(value: "24 meses", style: "body1"),
                                externalCode: "term"
                            ),
                            PurchaseProductModel.MetaData(
                                id: 4,
                                label: StringToken(value: "Rendimento Anual", style: "body2"),
                                description: nil,
                                value: StringToken(value: "14,4% a.a.", style: "body1"),
                                externalCode: "annual_yield"
                            ),
                            PurchaseProductModel.MetaData(
                                id: 5,
                                label: StringToken(value: "Pagamento", style: "body2"),
                                description: nil,
                                value: StringToken(value: "Mensal", style: "body1"),
                                externalCode: "payment_frequency"
                            )
                        ],
                        groups: nil
                    ),
                    externalCode: "ROY001",
                    assetSymbol: "ROY11",
                    documents: [
                        PurchaseProductModel.Document(
                            id: 1,
                            offerId: offerIdInt,
                            name: "Contrato de Royalties",
                            description: "Documento oficial do contrato",
                            imageIcon: "doc.text",
                            url: "https://example.com/contrato-royalties.pdf"
                        ),
                        PurchaseProductModel.Document(
                            id: 2,
                            offerId: offerIdInt,
                            name: "Termo de Investimento",
                            description: "Informações detalhadas sobre o investimento",
                            imageIcon: "doc.text",
                            url: "https://example.com/termo-royalties.pdf"
                        )
                    ]
                )
            )
        } else {
            // Investment Funds detail data
            return PurchaseDetailService.Response(
                data: PurchaseProductModel(
                    id: offerIdInt,
                    name: StringToken(value: "Fundo de Investimento ABC", style: "header4"),
                    description: StringToken(value: "Fundo focado em renda fixa com alta liquidez e segurança para seu patrimônio", style: "body1"),
                    imageIcon: "chart.bar.fill",
                    status: PurchaseProductModel.Status(id: 1, name: "Ativo"),
                    product: PurchaseProductModel.Product(
                        id: productIdInt,
                        name: StringToken(value: "Produto Investimento", style: "header3"),
                        description: StringToken(value: "Descrição do produto", style: "body1")
                    ),
                    productType: PurchaseProductModel.ProductType(
                        id: productTypeIdInt,
                        name: StringToken(value: "Fundo de Investimento", style: "header3"),
                        description: StringToken(value: "Diversifique sua carteira com fundos de investimento", style: "body1")
                    ),
                    information: PurchaseProductModel.Information(
                        metadatas: [
                            PurchaseProductModel.MetaData(
                                id: 1,
                                label: StringToken(value: "Rentabilidade", style: "body2"),
                                description: nil,
                                value: StringToken(value: "12,5% a.a.", style: "body1"),
                                externalCode: "rentability"
                            ),
                            PurchaseProductModel.MetaData(
                                id: 2,
                                label: StringToken(value: "Valor Mínimo", style: "body2"),
                                description: nil,
                                value: StringToken(value: "R$ 100,00", style: "body1"),
                                externalCode: "min_value"
                            ),
                            PurchaseProductModel.MetaData(
                                id: 3,
                                label: StringToken(value: "Liquidez", style: "body2"),
                                description: nil,
                                value: StringToken(value: "D+1", style: "body1"),
                                externalCode: "liquidity"
                            ),
                            PurchaseProductModel.MetaData(
                                id: 4,
                                label: StringToken(value: "Taxa de Administração", style: "body2"),
                                description: nil,
                                value: StringToken(value: "0,5% a.a.", style: "body1"),
                                externalCode: "admin_fee"
                            ),
                            PurchaseProductModel.MetaData(
                                id: 5,
                                label: StringToken(value: "Prazo de Resgate", style: "body2"),
                                description: nil,
                                value: StringToken(value: "Imediato", style: "body1"),
                                externalCode: "redemption_period"
                            )
                        ],
                        groups: nil
                    ),
                    externalCode: "ABC123",
                    assetSymbol: "ABC11",
                    documents: [
                        PurchaseProductModel.Document(
                            id: 1,
                            offerId: offerIdInt,
                            name: "Regulamento do Fundo",
                            description: "Documento oficial do fundo",
                            imageIcon: "doc.text",
                            url: "https://example.com/regulamento.pdf"
                        ),
                        PurchaseProductModel.Document(
                            id: 2,
                            offerId: offerIdInt,
                            name: "Prospecto",
                            description: "Informações detalhadas sobre o fundo",
                            imageIcon: "doc.text",
                            url: "https://example.com/prospecto.pdf"
                        )
                    ]
                )
            )
        }
    }
}

