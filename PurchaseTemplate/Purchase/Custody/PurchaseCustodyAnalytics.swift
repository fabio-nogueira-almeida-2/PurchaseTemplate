import CoreTrackingInterface

struct PurchaseCustodyAnalytics: AnalyticsKeyProtocol {
    typealias ButtonName = String
    let name: String
    let properties: [String: Any]

    private static let businessContextName = "__NOME_DO_CONTEXTO_AQUI__"
    private static let screenName = "__NOME_DA_TELA_AQUI__"

    private enum CustomKeys {
        static let buttonStatus = "button_status"
    }

    static let sceneButtonName: ButtonName = "__NOME_BOTAO__"
    static let faqButtonName: ButtonName = "__AJUDA__"

    static let screenViewed: Self = {
        let properties = [
            EventKeys.screenName: screenName,
            EventKeys.businessContext: businessContextName
        ]
        return .init(
            name: EventName.screenViewed,
            properties: properties
        )
    }()

    static func buttonClicked(_ buttonName: ButtonName, buttonStatus: String) -> Self {
        let properties = [
            EventKeys.screenName: screenName,
            EventKeys.businessContext: businessContextName,
            EventKeys.buttonName: buttonName,
            CustomKeys.buttonStatus: buttonStatus
        ]

        return .init(
            name: EventName.buttonClicked,
            properties: properties
        )
    }

    func event() -> AnalyticsEventProtocol {
        AnalyticsEvent(name, properties: properties)
    }
}
