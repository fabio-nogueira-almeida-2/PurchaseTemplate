# Fabio's Investment Flows - System Design (Mermaid)

## Main System Architecture

```mermaid
graph TB
    subgraph "Investment Flows System"
        subgraph "Presentation Layer (VIP)"
            VC[View Controllers]
            P[Presenters]
            I[Interactors]
            
            PCVC[PurchaseCustodyViewController]
            PDVC[PurchaseDetailViewController]
            PLVC[PurchaseListViewController]
            OVC[OrdersViewController]
            PRVC[PurchaseResultViewController]
            
            PCP[PurchaseCustodyPresenter]
            PDP[PurchaseDetailPresenter]
            PLP[PurchaseListPresenter]
            OP[OrdersPresenter]
            PRP[PurchaseResultPresenter]
            
            PCI[PurchaseCustodyInteractor]
            PDI[PurchaseDetailInteractor]
            PLI[PurchaseListInteractor]
            OI[OrdersInteractor]
            PRI[PurchaseResultInteractor]
        end
        
        subgraph "Navigation & Coordination"
            C[Coordinators]
            DLR[Deep Link Resolvers]
            NM[Navigation Manager]
            
            PCC[PurchaseCustodyCoordinator]
            PDC[PurchaseDetailCoordinator]
            PLC[PurchaseListCoordinator]
            OC[OrdersCoordinator]
            PRC[PurchaseResultCoordinator]
            
            PCDLR[PurchaseCustodyDeeplinkResolver]
            PDDLR[PurchaseDetailDeeplinkResolver]
            PLDLR[PurchaseListDeeplinkResolver]
            ODLR[OrdersDeeplinkResolver]
            PRDLR[PurchaseResultDeeplinkResolver]
        end
        
        subgraph "Service Layer"
            AS[API Services]
            CS[Core Service]
            EH[Error Handler]
            NM2[Network Manager]
            
            PCS[PurchaseCustodyService]
            PDS[PurchaseDetailService]
            PLS[PurchaseListService]
            OS[OrdersService]
            PRS[PurchaseResultService]
        end
        
        subgraph "Backend Template Architecture"
            STS[StringToken System]
            MP[Metadata Processor]
            CR[Content Renderer]
            
            STP[StringToken Parser]
            TE[Typography Engine]
            SP[Style Processor]
            
            MP2[Metadata Parser]
            DCG[Dynamic Content Generator]
            FM[Field Mapper]
            
            DUB[Dynamic UI Builder]
            TE2[Template Engine]
            LM[Layout Manager]
        end
        
        subgraph "Infrastructure"
            DI[Dependency Injection]
            AT[Analytics & Tracking]
            SP2[Security & Privacy]
            
            DC[DependencyContainer]
            FP[Factory Pattern]
            SL[Service Locator]
            
            ET[Event Tracker]
            UA[User Analytics]
            PM[Performance Monitor]
            
            AUTH[Authentication]
            PV[PIN Validation]
            SM[Safe Mode]
            DE[Data Encryption]
        end
    end
    
    subgraph "External Systems"
        API[Backend API]
        IA[Investment API]
        UD[User Data]
        PC[Product Catalog]
        OM[Order Management]
        
        ES[External Services]
        DLH[Deep Link Handler]
        WVS[WebView Service]
        AS2[Analytics Service]
    end
    
    %% Data Flow Connections
    VC --> P
    P --> I
    I --> AS
    AS --> CS
    CS --> API
    
    %% Navigation Flow
    C --> VC
    DLR --> C
    NM --> C
    
    %% Backend Template Flow
    I --> STS
    STS --> MP
    MP --> CR
    CR --> VC
    
    %% Infrastructure Flow
    DI --> VC
    DI --> I
    DI --> AS
    
    AT --> I
    SP2 --> I
    
    %% External Connections
    CS --> IA
    CS --> UD
    CS --> PC
    CS --> OM
    
    DLH --> DLR
    WVS --> C
    AS2 --> AT
    
    %% Styling
    classDef presentation fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    classDef navigation fill:#F3E5F5,stroke:#7B1FA2,stroke-width:2px
    classDef service fill:#E8F5E8,stroke:#388E3C,stroke-width:2px
    classDef backend fill:#FFF3E0,stroke:#F57C00,stroke-width:2px
    classDef infrastructure fill:#FCE4EC,stroke:#C2185B,stroke-width:2px
    classDef external fill:#F1F8E9,stroke:#689F38,stroke-width:2px
    
    class VC,P,I,PCVC,PDVC,PLVC,OVC,PRVC,PCP,PDP,PLP,OP,PRP,PCI,PDI,PLI,OI,PRI presentation
    class C,DLR,NM,PCC,PDC,PLC,OC,PRC,PCDLR,PDDLR,PLDLR,ODLR,PRDLR navigation
    class AS,CS,EH,NM2,PCS,PDS,PLS,OS,PRS service
    class STS,MP,CR,STP,TE,SP,MP2,DCG,FM,DUB,TE2,LM backend
    class DI,AT,SP2,DC,FP,SL,ET,UA,PM,AUTH,PV,SM,DE infrastructure
    class API,IA,UD,PC,OM,ES,DLH,WVS,AS2 external
```

## Component Interaction Flow

```mermaid
sequenceDiagram
    participant U as User
    participant VC as View Controller
    participant I as Interactor
    participant S as Service
    participant API as Backend API
    participant STS as StringToken System
    participant MP as Metadata Processor
    participant P as Presenter
    participant C as Coordinator

    Note over U,C: User Interaction Flow

    U->>VC: User taps investment option
    activate VC
    
    VC->>I: loadOffer()
    activate I
    
    I->>S: getOffer(productId, offerId)
    activate S
    
    S->>API: HTTP GET /products/{id}/offers/{offerId}
    activate API
    
    API-->>S: PurchaseProductModel with StringTokens
    deactivate API
    
    S-->>I: Response with metadata
    deactivate S
    
    I->>STS: Process StringTokens
    activate STS
    
    STS->>MP: Parse metadata structure
    activate MP
    
    MP-->>STS: Processed content fields
    deactivate MP
    
    STS-->>I: StringWithTypograph objects
    deactivate STS
    
    I->>P: present(model: PurchaseProductModel)
    activate P
    
    P->>P: createDTO() - Transform to presentation model
    P->>P: generateSections() - Create dynamic sections
    P->>P: generateDocument() - Process documents
    
    P-->>VC: display(dto: PurchaseDetailDTO)
    deactivate P
    
    VC->>VC: Update UI with dynamic content
    deactivate I
    
    VC-->>U: Display investment details
    deactivate VC

    Note over U,C: Navigation Flow

    U->>VC: User taps "Invest" button
    activate VC
    
    VC->>I: didTapInvest()
    activate I
    
    I->>P: presentInputValueScreen(model)
    activate P
    
    P->>C: navigateToInputValue()
    activate C
    
    C->>C: Create new ViewController with dependencies
    C-->>VC: Push to InputValue screen
    deactivate C
    deactivate P
    deactivate I
    deactivate VC

    Note over STS,MP: Backend Template Architecture
    
    Note over STS,MP: 1. StringToken Processing:<br/>- Parse value and style from backend<br/>- Map to PurchaseTypograph enum<br/>- Create StringWithTypograph objects
    
    Note over STS,MP: 2. Metadata Processing:<br/>- Parse complex metadata structures<br/>- Generate dynamic field mappings<br/>- Create section-based layouts
    
    Note over STS,MP: 3. Dynamic Content Generation:<br/>- Build UI components from metadata<br/>- Apply backend-controlled styling<br/>- Support A/B testing variations
```

## Architecture Layers

```mermaid
graph TB
    subgraph "Presentation Layer"
        subgraph "View Layer"
            VC[View Controllers]
            CV[Custom Views]
            TVC[Table View Cells]
            HV[Header Views]
        end
        
        subgraph "Presenter Layer"
            P[Presenters]
            VM[View Models]
            DT[Data Transformers]
        end
        
        subgraph "Interactor Layer"
            I[Interactors]
            BL[Business Logic]
            UC[Use Cases]
        end
    end
    
    subgraph "Navigation Layer"
        C[Coordinators]
        DLR[Deep Link Resolvers]
        NM[Navigation Manager]
        FC[Flow Controllers]
    end
    
    subgraph "Service Layer"
        AS[API Services]
        CS[Core Service]
        NM2[Network Manager]
        EH[Error Handler]
        RRM[Request/Response Models]
    end
    
    subgraph "Backend Template Layer"
        STS[StringToken System]
        MP[Metadata Processor]
        CR[Content Renderer]
        TE[Typography Engine]
        DUB[Dynamic UI Builder]
    end
    
    subgraph "Infrastructure Layer"
        DI[Dependency Injection]
        FP[Factory Pattern]
        SL[Service Locator]
        CFG[Configuration]
    end
    
    subgraph "Cross-Cutting Concerns"
        AT[Analytics & Tracking]
        SP[Security & Privacy]
        EH2[Error Handling]
        PM[Performance Monitoring]
        LOG[Logging]
    end
    
    subgraph "External Dependencies"
        API[Backend API]
        DLH[Deep Link Handler]
        WVS[WebView Service]
        AS2[Analytics Service]
        AUTH[Authentication Service]
    end
    
    %% Layer Dependencies
    VC --> P
    P --> I
    I --> AS
    
    C --> VC
    DLR --> C
    NM --> C
    
    AS --> CS
    CS --> API
    
    I --> STS
    STS --> MP
    MP --> CR
    
    DI --> VC
    DI --> I
    DI --> AS
    
    AT --> I
    SP --> I
    EH2 --> I
    
    %% Styling
    classDef presentation fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    classDef navigation fill:#F3E5F5,stroke:#7B1FA2,stroke-width:2px
    classDef service fill:#E8F5E8,stroke:#388E3C,stroke-width:2px
    classDef backend fill:#FFF3E0,stroke:#F57C00,stroke-width:2px
    classDef infrastructure fill:#FCE4EC,stroke:#C2185B,stroke-width:2px
    classDef external fill:#F1F8E9,stroke:#689F38,stroke-width:2px
    
    class VC,CV,TVC,HV,P,VM,DT,I,BL,UC presentation
    class C,DLR,NM,FC navigation
    class AS,CS,NM2,EH,RRM service
    class STS,MP,CR,TE,DUB backend
    class DI,FP,SL,CFG infrastructure
    class AT,SP,EH2,PM,LOG external
    class API,DLH,WVS,AS2,AUTH external
```

## Backend Template Data Flow

```mermaid
graph LR
    subgraph "Backend Template Architecture"
        API[Backend API]
        PD[Product Data]
        STC[StringToken Content]
        MS[Metadata Structure]
        SI[Styling Information]
        
        STP[StringToken Parser]
        VE[Value Extraction]
        SM[Style Mapping]
        TR[Typography Resolution]
        
        MP[Metadata Processor]
        FM[Field Mapping]
        SG[Section Generation]
        CO[Content Organization]
        
        DCG[Dynamic Content Generator]
        UCB[UI Component Builder]
        LM[Layout Manager]
        TE[Template Engine]
        
        RUI[Rendered UI]
        DL[Dynamic Labels]
        ST[Styled Text]
        OS[Organized Sections]
        IE[Interactive Elements]
    end
    
    %% Data Flow
    API --> STP
    STP --> MP
    MP --> DCG
    DCG --> RUI
    
    PD --> STP
    STC --> STP
    MS --> MP
    SI --> STP
    
    VE --> STP
    SM --> STP
    TR --> STP
    
    FM --> MP
    SG --> MP
    CO --> MP
    
    UCB --> DCG
    LM --> DCG
    TE --> DCG
    
    DL --> RUI
    ST --> RUI
    OS --> RUI
    IE --> RUI
    
    %% Styling
    classDef api fill:#E8F5E8,stroke:#388E3C,stroke-width:3px
    classDef parser fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    classDef processor fill:#FFF3E0,stroke:#F57C00,stroke-width:2px
    classDef generator fill:#F3E5F5,stroke:#7B1FA2,stroke-width:2px
    classDef ui fill:#FCE4EC,stroke:#C2185B,stroke-width:2px
    
    class API,PD,STC,MS,SI api
    class STP,VE,SM,TR parser
    class MP,FM,SG,CO processor
    class DCG,UCB,LM,TE generator
    class RUI,DL,ST,OS,IE ui
```

## System Benefits Summary

```mermaid
mindmap
  root((Fabio's Investment Flows))
    Backend Template Architecture
      Dynamic Content
        Backend controls all text and styling
        A/B testing capability
        Rapid content iteration
        Consistent styling across flows
      Multi-language Support
        Localization through backend
        Dynamic language switching
        Cultural adaptation
      Performance Optimization
        Efficient rendering
        Smart caching
        Lazy loading
    VIP Architecture
      Clean Separation
        View layer for UI
        Interactor for business logic
        Presenter for data transformation
      Testability
        Easy mocking
        Unit testing
        Integration testing
      Maintainability
        Single responsibility
        Loose coupling
        Easy to extend
    Navigation & Coordination
      Flexible Navigation
        Coordinator pattern
        Deep linking support
        Flow management
      Dependency Injection
        Loose coupling
        Testability
        Service location
    Infrastructure
      Security & Privacy
        PIN authentication
        Safe mode
        Data encryption
      Analytics & Tracking
        User behavior tracking
        Performance monitoring
        Business insights
      Error Handling
        Comprehensive error management
        User-friendly messages
        Graceful degradation
```
