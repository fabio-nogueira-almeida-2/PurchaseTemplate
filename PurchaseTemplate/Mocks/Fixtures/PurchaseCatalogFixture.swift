//
//  PurchaseCatalogFixture.swift
//  PurchaseTemplate
//
//  Mock fixture data for Catalog screen - shows ALL investments regardless of type
//

import Foundation

struct PurchaseCatalogFixture {
    static func mockResponse() -> PurchaseCatalogService.Response {
        // Combine both Investment Funds and Royalties Investment
        var allInvestments: [PurchaseProductModel] = []
        
        // Investment Funds (productTypeId: 1)
        allInvestments.append(contentsOf: [
            PurchaseProductModel(
                id: 1,
                name: StringToken(value: "Fundo de Investimento ABC", style: "header4"),
                description: StringToken(value: "Fundo focado em renda fixa com alta liquidez", style: "body1"),
                imageIcon: "chart.bar.fill",
                status: PurchaseProductModel.Status(id: 1, name: "Ativo"),
                product: PurchaseProductModel.Product(
                    id: 1,
                    name: StringToken(value: "Produto Investimento", style: "header3"),
                    description: StringToken(value: "Descrição do produto", style: "body1")
                ),
                productType: PurchaseProductModel.ProductType(
                    id: 1,
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
                        )
                    ],
                    groups: nil
                ),
                externalCode: "ABC123",
                assetSymbol: "ABC11",
                documents: nil
            ),
            PurchaseProductModel(
                id: 2,
                name: StringToken(value: "Fundo de Investimento XYZ", style: "header4"),
                description: StringToken(value: "Fundo multimercado com foco em crescimento", style: "body1"),
                imageIcon: "chart.line.uptrend.xyaxis",
                status: PurchaseProductModel.Status(id: 1, name: "Ativo"),
                product: PurchaseProductModel.Product(
                    id: 1,
                    name: StringToken(value: "Produto Investimento", style: "header3"),
                    description: StringToken(value: "Descrição do produto", style: "body1")
                ),
                productType: PurchaseProductModel.ProductType(
                    id: 1,
                    name: StringToken(value: "Fundo de Investimento", style: "header3"),
                    description: StringToken(value: "Diversifique sua carteira com fundos de investimento", style: "body1")
                ),
                information: PurchaseProductModel.Information(
                    metadatas: [
                        PurchaseProductModel.MetaData(
                            id: 1,
                            label: StringToken(value: "Rentabilidade", style: "body2"),
                            description: nil,
                            value: StringToken(value: "15,2% a.a.", style: "body1"),
                            externalCode: "rentability"
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
                            label: StringToken(value: "Liquidez", style: "body2"),
                            description: nil,
                            value: StringToken(value: "D+30", style: "body1"),
                            externalCode: "liquidity"
                        )
                    ],
                    groups: nil
                ),
                externalCode: "XYZ456",
                assetSymbol: "XYZ11",
                documents: nil
            )
        ])
        
        // Royalties Investment (productTypeId: 2)
        allInvestments.append(contentsOf: [
            PurchaseProductModel(
                id: 3,
                name: StringToken(value: "Royalties Música Pop", style: "header4"),
                description: StringToken(value: "Receba rendimentos mensais de royalties musicais", style: "body1"),
                imageIcon: "music.note",
                status: PurchaseProductModel.Status(id: 1, name: "Ativo"),
                product: PurchaseProductModel.Product(
                    id: 2,
                    name: StringToken(value: "Royalties Musicais", style: "header3"),
                    description: StringToken(value: "Invista em royalties de música", style: "body1")
                ),
                productType: PurchaseProductModel.ProductType(
                    id: 2,
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
                        )
                    ],
                    groups: nil
                ),
                externalCode: "ROY001",
                assetSymbol: "ROY11",
                documents: nil
            ),
            PurchaseProductModel(
                id: 4,
                name: StringToken(value: "Royalties Filmes", style: "header4"),
                description: StringToken(value: "Invista em royalties de produções cinematográficas", style: "body1"),
                imageIcon: "film",
                status: PurchaseProductModel.Status(id: 1, name: "Ativo"),
                product: PurchaseProductModel.Product(
                    id: 2,
                    name: StringToken(value: "Royalties Cinematográficos", style: "header3"),
                    description: StringToken(value: "Descrição do produto", style: "body1")
                ),
                productType: PurchaseProductModel.ProductType(
                    id: 2,
                    name: StringToken(value: "Royalties", style: "header3"),
                    description: StringToken(value: "Receba rendimentos mensais previsíveis", style: "body1")
                ),
                information: PurchaseProductModel.Information(
                    metadatas: [
                        PurchaseProductModel.MetaData(
                            id: 1,
                            label: StringToken(value: "Rendimento Mensal", style: "body2"),
                            description: nil,
                            value: StringToken(value: "1,5% a.m.", style: "body1"),
                            externalCode: "monthly_yield"
                        ),
                        PurchaseProductModel.MetaData(
                            id: 2,
                            label: StringToken(value: "Valor Mínimo", style: "body2"),
                            description: nil,
                            value: StringToken(value: "R$ 1.000,00", style: "body1"),
                            externalCode: "min_value"
                        ),
                        PurchaseProductModel.MetaData(
                            id: 3,
                            label: StringToken(value: "Prazo", style: "body2"),
                            description: nil,
                            value: StringToken(value: "36 meses", style: "body1"),
                            externalCode: "term"
                        )
                    ],
                    groups: nil
                ),
                externalCode: "ROY002",
                assetSymbol: "ROY22",
                documents: nil
            )
        ])
        
        return PurchaseCatalogService.Response(data: allInvestments)
    }
}

