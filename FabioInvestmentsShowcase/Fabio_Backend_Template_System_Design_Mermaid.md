# Fabio's Backend Template Architecture - System Design (Mermaid)

## Backend Template Architecture Overview

```mermaid
graph TB
    subgraph "Backend Template System"
        subgraph "Backend API Layer"
            API[Backend API]
            PD[Product Data]
            STC[StringToken Content]
            MS[Metadata Structure]
            SI[Styling Information]
        end
        
        subgraph "StringToken Processing Layer"
            STP[StringToken Parser]
            VE[Value Extraction]
            SM[Style Mapping]
            TR[Typography Resolution]
            TE[Typography Engine]
        end
        
        subgraph "Metadata Processing Layer"
            MP[Metadata Processor]
            FM[Field Mapping]
            SG[Section Generation]
            CO[Content Organization]
            DCG[Dynamic Content Generator]
        end
        
        subgraph "Content Rendering Layer"
            CR[Content Renderer]
            DUB[Dynamic UI Builder]
            LM[Layout Manager]
            TE2[Template Engine]
            UCB[UI Component Builder]
        end
        
        subgraph "Rendered UI Layer"
            RUI[Rendered UI]
            DL[Dynamic Labels]
            ST[Styled Text]
            OS[Organized Sections]
            IE[Interactive Elements]
        end
    end
    
    subgraph "Mobile App Integration"
        subgraph "VIP Architecture"
            VC[View Controllers]
            P[Presenters]
            I[Interactors]
        end
        
        subgraph "Template Integration"
            STS[StringToken System]
            MP2[Metadata Processor]
            CR2[Content Renderer]
        end
    end
    
    %% Data Flow
    API --> STP
    PD --> STP
    STC --> STP
    MS --> MP
    SI --> STP
    
    STP --> MP
    VE --> STP
    SM --> STP
    TR --> STP
    TE --> STP
    
    MP --> DCG
    FM --> MP
    SG --> MP
    CO --> MP
    
    DCG --> CR
    DUB --> CR
    LM --> CR
    TE2 --> CR
    UCB --> CR
    
    CR --> RUI
    DL --> RUI
    ST --> RUI
    OS --> RUI
    IE --> RUI
    
    %% Mobile Integration
    I --> STS
    STS --> MP2
    MP2 --> CR2
    CR2 --> VC
    
    %% Styling
    classDef backend fill:#E8F5E8,stroke:#388E3C,stroke-width:3px
    classDef parser fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    classDef processor fill:#FFF3E0,stroke:#F57C00,stroke-width:2px
    classDef renderer fill:#F3E5F5,stroke:#7B1FA2,stroke-width:2px
    classDef ui fill:#FCE4EC,stroke:#C2185B,stroke-width:2px
    classDef mobile fill:#F1F8E9,stroke:#689F38,stroke-width:2px
    
    class API,PD,STC,MS,SI backend
    class STP,VE,SM,TR,TE parser
    class MP,FM,SG,CO,DCG processor
    class CR,DUB,LM,TE2,UCB renderer
    class RUI,DL,ST,OS,IE ui
    class VC,P,I,STS,MP2,CR2 mobile
```

## StringToken System Detailed Flow

```mermaid
sequenceDiagram
    participant API as Backend API
    participant STP as StringToken Parser
    participant TE as Typography Engine
    participant MP as Metadata Processor
    participant CR as Content Renderer
    participant UI as Rendered UI

    Note over API,UI: StringToken Processing Flow

    API->>STP: Raw StringToken Data
    Note right of API: {"value": "Investment Title", "style": "header1"}
    
    STP->>STP: Parse value and style
    STP->>TE: Map style to PurchaseTypograph
    TE->>TE: Resolve typography rules
    TE-->>STP: PurchaseTypograph enum
    
    STP->>STP: Create StringWithTypograph object
    Note right of STP: StringWithTypograph(value: "Investment Title", typograph: .header1)
    
    STP->>MP: Processed StringWithTypograph
    MP->>MP: Generate field mappings
    MP->>MP: Create section layouts
    MP->>MP: Organize content structure
    
    MP->>CR: Processed metadata
    CR->>CR: Build UI components
    CR->>CR: Apply backend-controlled styling
    CR->>CR: Support A/B testing variations
    
    CR->>UI: Dynamic UI components
    Note right of UI: Styled labels, organized sections, interactive elements
    
    UI-->>API: Rendered investment interface
```

## Metadata Processing Architecture

```mermaid
graph LR
    subgraph "Input Layer"
        API[Backend API]
        JSON[JSON Response]
        ST[StringTokens]
        MD[Metadata Arrays]
    end
    
    subgraph "Processing Layer"
        subgraph "StringToken Processing"
            STP[StringToken Parser]
            VE[Value Extraction]
            SM[Style Mapping]
            TR[Typography Resolution]
        end
        
        subgraph "Metadata Processing"
            MP[Metadata Processor]
            FM[Field Mapping]
            SG[Section Generation]
            CO[Content Organization]
        end
        
        subgraph "Content Generation"
            DCG[Dynamic Content Generator]
            UCB[UI Component Builder]
            LM[Layout Manager]
            TE[Template Engine]
        end
    end
    
    subgraph "Output Layer"
        subgraph "Rendered Components"
            DL[Dynamic Labels]
            ST2[Styled Text]
            OS[Organized Sections]
            IE[Interactive Elements]
        end
        
        subgraph "UI Integration"
            VC[View Controllers]
            TVC[Table View Cells]
            HV[Header Views]
            CV[Custom Views]
        end
    end
    
    %% Data Flow
    API --> JSON
    JSON --> ST
    JSON --> MD
    
    ST --> STP
    STP --> VE
    STP --> SM
    STP --> TR
    
    MD --> MP
    MP --> FM
    MP --> SG
    MP --> CO
    
    VE --> DCG
    SM --> DCG
    TR --> DCG
    FM --> DCG
    SG --> DCG
    CO --> DCG
    
    DCG --> UCB
    DCG --> LM
    DCG --> TE
    
    UCB --> DL
    LM --> ST2
    TE --> OS
    DCG --> IE
    
    DL --> VC
    ST2 --> TVC
    OS --> HV
    IE --> CV
    
    %% Styling
    classDef input fill:#E8F5E8,stroke:#388E3C,stroke-width:2px
    classDef processing fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    classDef output fill:#FCE4EC,stroke:#C2185B,stroke-width:2px
    classDef ui fill:#F3E5F5,stroke:#7B1FA2,stroke-width:2px
    
    class API,JSON,ST,MD input
    class STP,VE,SM,TR,MP,FM,SG,CO,DCG,UCB,LM,TE processing
    class DL,ST2,OS,IE output
    class VC,TVC,HV,CV ui
```

## Backend Template Benefits & Features

```mermaid
mindmap
  root((Backend Template Architecture))
    Dynamic Content Management
      StringToken System
        Value and style separation
        Typography control
        A/B testing support
        Localization ready
      Metadata Processing
        Complex data structures
        Dynamic field mapping
        Section-based layouts
        Content organization
    Backend Control
      Content Updates
        No app store releases
        Real-time content changes
        A/B testing capability
        Feature flagging
      Styling Control
        Backend-driven styling
        Consistent design system
        Theme management
        Responsive design
    Performance Optimization
      Efficient Rendering
        Smart caching
        Lazy loading
        Memory optimization
        Network efficiency
      Content Delivery
        CDN integration
        Compression
        Progressive loading
        Offline support
    Developer Experience
      Maintainability
        Clean architecture
        Separation of concerns
        Easy testing
        Documentation
      Scalability
        Modular design
        Extensible framework
        Reusable components
        Version management
    User Experience
      Personalization
        Dynamic content
        User preferences
        Contextual information
        Adaptive interfaces
      Accessibility
        Screen reader support
        High contrast modes
        Font scaling
        Voice over support
```

## Template Feature Implementation Flow

```mermaid
flowchart TD
    Start([User Opens Investment Flow]) --> API[Backend API Call]
    
    API --> ST{StringToken Processing}
    ST --> VE[Extract Value & Style]
    VE --> SM[Map to PurchaseTypograph]
    SM --> TE[Apply Typography Rules]
    TE --> STO[Create StringWithTypograph]
    
    STO --> MP{Metadata Processing}
    MP --> FM[Generate Field Mappings]
    FM --> SG[Create Section Layouts]
    SG --> CO[Organize Content Structure]
    
    CO --> DCG{Dynamic Content Generation}
    DCG --> UCB[Build UI Components]
    UCB --> LM[Apply Layout Rules]
    LM --> TE2[Process Templates]
    
    TE2 --> CR{Content Rendering}
    CR --> DL[Render Dynamic Labels]
    DL --> ST[Apply Styled Text]
    ST --> OS[Organize Sections]
    OS --> IE[Add Interactive Elements]
    
    IE --> VC[Update View Controller]
    VC --> UI[Display to User]
    
    UI --> End([User Sees Dynamic Content])
    
    %% Error Handling
    ST -->|Error| EH[Error Handler]
    MP -->|Error| EH
    DCG -->|Error| EH
    CR -->|Error| EH
    
    EH --> EC[Error Content]
    EC --> VC
    
    %% Styling
    classDef process fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    classDef decision fill:#FFF3E0,stroke:#F57C00,stroke-width:2px
    classDef output fill:#E8F5E8,stroke:#388E3C,stroke-width:2px
    classDef error fill:#FFEBEE,stroke:#D32F2F,stroke-width:2px
    
    class API,VE,SM,TE,STO,FM,SG,CO,UCB,LM,TE2,DL,ST,OS,IE,VC,UI process
    class ST,MP,DCG,CR decision
    class End output
    class EH,EC error
```

## Template System Components

```mermaid
graph TB
    subgraph "Core Template Components"
        subgraph "StringToken System"
            ST[StringToken]
            SWT[StringWithTypograph]
            PT[PurchaseTypograph]
            TE[Typography Engine]
        end
        
        subgraph "Metadata System"
            MD[Metadata Arrays]
            FM[Field Mapper]
            SG[Section Generator]
            CO[Content Organizer]
        end
        
        subgraph "Rendering System"
            CR[Content Renderer]
            DUB[Dynamic UI Builder]
            LM[Layout Manager]
            TE2[Template Engine]
        end
    end
    
    subgraph "Integration Points"
        subgraph "VIP Architecture"
            I[Interactors]
            P[Presenters]
            VC[View Controllers]
        end
        
        subgraph "Service Layer"
            AS[API Services]
            CS[Core Service]
            EH[Error Handler]
        end
    end
    
    subgraph "Output Components"
        subgraph "UI Elements"
            DL[Dynamic Labels]
            ST2[Styled Text]
            OS[Organized Sections]
            IE[Interactive Elements]
        end
        
        subgraph "View Components"
            TVC[Table View Cells]
            HV[Header Views]
            CV[Custom Views]
            BV[Base Views]
        end
    end
    
    %% Connections
    ST --> SWT
    SWT --> PT
    PT --> TE
    
    MD --> FM
    FM --> SG
    SG --> CO
    
    CR --> DUB
    DUB --> LM
    LM --> TE2
    
    I --> ST
    P --> MD
    VC --> CR
    
    AS --> I
    CS --> AS
    EH --> I
    
    DL --> TVC
    ST2 --> HV
    OS --> CV
    IE --> BV
    
    %% Styling
    classDef core fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    classDef integration fill:#F3E5F5,stroke:#7B1FA2,stroke-width:2px
    classDef output fill:#E8F5E8,stroke:#388E3C,stroke-width:2px
    
    class ST,SWT,PT,TE,MD,FM,SG,CO,CR,DUB,LM,TE2 core
    class I,P,VC,AS,CS,EH integration
    class DL,ST2,OS,IE,TVC,HV,CV,BV output
```

## Template Feature Benefits Summary

```mermaid
graph LR
    subgraph "Backend Template Benefits"
        subgraph "Content Management"
            DC[Dynamic Content]
            AB[A/B Testing]
            RT[Real-time Updates]
            LC[Localization]
        end
        
        subgraph "Development Benefits"
            CM[Clean Architecture]
            TE[Easy Testing]
            MD[Maintainable Code]
            SC[Scalable Design]
        end
        
        subgraph "Performance Benefits"
            EF[Efficient Rendering]
            SM[Smart Caching]
            LO[Lazy Loading]
            OP[Optimized Performance]
        end
        
        subgraph "User Experience"
            PE[Personalized Experience]
            AC[Accessibility]
            RE[Responsive Design]
            SE[Seamless Experience]
        end
    end
    
    %% Benefit Connections
    DC --> PE
    AB --> RE
    RT --> SE
    LC --> AC
    
    CM --> TE
    TE --> MD
    MD --> SC
    
    EF --> OP
    SM --> EF
    LO --> SM
    
    PE --> SE
    AC --> PE
    RE --> AC
    
    %% Styling
    classDef content fill:#E8F5E8,stroke:#388E3C,stroke-width:2px
    classDef development fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    classDef performance fill:#FFF3E0,stroke:#F57C00,stroke-width:2px
    classDef experience fill:#FCE4EC,stroke:#C2185B,stroke-width:2px
    
    class DC,AB,RT,LC content
    class CM,TE,MD,SC development
    class EF,SM,LO,OP performance
    class PE,AC,RE,SE experience
```
