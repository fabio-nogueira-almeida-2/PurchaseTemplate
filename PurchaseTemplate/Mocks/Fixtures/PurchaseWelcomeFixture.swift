//
//  PurchaseWelcomeFixture.swift
//  PurchaseTemplate
//
//  Mock fixture data for Purchase Welcome screen
//

import Foundation

struct PurchaseWelcomeFixture {
    static func mockResponse() -> PurchaseWelcomeServicingModel.Response {
        return PurchaseWelcomeServicingModel.Response(
            data: PurchaseWelcomeServicingModel.PurchaseWelcomeModel(
                productId: 1,
                productTypeId: 1,
                name: StringToken(value: "Bem-vindo ao Investimento", style: "header1"),
                description: StringToken(value: "Descubra oportunidades de investimento exclusivas e diversifique sua carteira com segurança.", style: "body1"),
                nextDeepLinkName: StringToken(value: "Ver Ofertas", style: "PrimaryMedium"),
                nextDeepLink: "\(DeeplinkConfig.baseURL)purchase/offers?productId=1&productTypeId=1",
                imageUrl: "https://via.placeholder.com/64",
                items: [
                    PurchaseWelcomeServicingModel.MenuItem(
                        name: StringToken(value: "Investimento Seguro", style: "header4"),
                        description: StringToken(value: "Seus investimentos são protegidos por regulamentações rigorosas", style: "note"),
                        nextDeepLink: "\(DeeplinkConfig.baseURL)help/investment",
                        imageIcon: "shield.checkmark"
                    ),
                    PurchaseWelcomeServicingModel.MenuItem(
                        name: StringToken(value: "Rentabilidade", style: "header4"),
                        description: StringToken(value: "Acompanhe seus rendimentos em tempo real", style: "note"),
                        nextDeepLink: "\(DeeplinkConfig.baseURL)purchase/custody",
                        imageIcon: "chart.line.uptrend.xyaxis"
                    ),
                    PurchaseWelcomeServicingModel.MenuItem(
                        name: StringToken(value: "Suporte", style: "header4"),
                        description: StringToken(value: "Tire suas dúvidas com nossa equipe especializada", style: "note"),
                        nextDeepLink: "\(DeeplinkConfig.baseURL)help",
                        imageIcon: "questionmark.circle"
                    ),
                    PurchaseWelcomeServicingModel.MenuItem(
                        name: StringToken(value: "Documentos", style: "header4"),
                        description: StringToken(value: "Acesse todos os documentos importantes", style: "note"),
                        nextDeepLink: "\(DeeplinkConfig.baseURL)documents",
                        imageIcon: "doc.text"
                    )
                ]
            )
        )
    }
    
    static func mockResponseForProduct(productId: String, productTypeId: String) -> PurchaseWelcomeServicingModel.Response {
        let productIdInt = Int(productId) ?? 1
        let productTypeIdInt = Int(productTypeId) ?? 1
        
        // Different content based on investment type
        let isRoyalties = productTypeIdInt == 2
        
        let name = isRoyalties 
            ? "Bem-vindo aos Royalties"
            : "Bem-vindo aos Fundos de Investimento"
        
        let description = isRoyalties
            ? "Invista em royalties e receba rendimentos mensais de forma segura e previsível."
            : "Descubra oportunidades de investimento exclusivas e diversifique sua carteira com segurança."
        
        let nextDeepLinkName = isRoyalties
            ? "Ver Royalties Disponíveis"
            : "Ver Ofertas"
        
        return PurchaseWelcomeServicingModel.Response(
            data: PurchaseWelcomeServicingModel.PurchaseWelcomeModel(
                productId: productIdInt,
                productTypeId: productTypeIdInt,
                name: StringToken(value: name, style: "header1"),
                description: StringToken(value: description, style: "body1"),
                nextDeepLinkName: StringToken(value: nextDeepLinkName, style: "PrimaryMedium"),
                nextDeepLink: "\(DeeplinkConfig.baseURL)purchase/offers?productId=\(productId)&productTypeId=\(productTypeId)",
                imageUrl: isRoyalties ? "https://via.placeholder.com/64?text=Royalties" : "https://via.placeholder.com/64?text=Fundos",
                items: [
                    PurchaseWelcomeServicingModel.MenuItem(
                        name: StringToken(value: isRoyalties ? "Rendimentos Mensais" : "Investimento Seguro", style: "header4"),
                        description: StringToken(value: isRoyalties ? "Receba rendimentos mensais previsíveis" : "Seus investimentos são protegidos por regulamentações rigorosas", style: "note"),
                        nextDeepLink: "\(DeeplinkConfig.baseURL)help/investment",
                        imageIcon: isRoyalties ? "calendar" : "shield.checkmark"
                    ),
                    PurchaseWelcomeServicingModel.MenuItem(
                        name: StringToken(value: "Rentabilidade", style: "header4"),
                        description: StringToken(value: "Acompanhe seus rendimentos em tempo real", style: "note"),
                        nextDeepLink: "\(DeeplinkConfig.baseURL)purchase/custody",
                        imageIcon: "chart.line.uptrend.xyaxis"
                    ),
                    PurchaseWelcomeServicingModel.MenuItem(
                        name: StringToken(value: "Suporte", style: "header4"),
                        description: StringToken(value: "Tire suas dúvidas com nossa equipe especializada", style: "note"),
                        nextDeepLink: "\(DeeplinkConfig.baseURL)help",
                        imageIcon: "questionmark.circle"
                    )
                ]
            )
        )
    }
}

