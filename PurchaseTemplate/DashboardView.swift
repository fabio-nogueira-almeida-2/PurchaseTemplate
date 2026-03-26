//
//  DashboardView.swift
//  PurchaseTemplate
//
//  Dashboard view with investment type selection
//

import SwiftUI

struct DashboardView: View {
    @State private var selectedInvestmentType: InvestmentType?
    
    enum InvestmentType {
        case catalog
        case investmentFunds
        case royaltiesInvestment
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    SwiftUI.Text("Purchase Template")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    SwiftUI.Text("Select an investment type")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Investment Type Options
                VStack(spacing: 16) {
                    // Catalog Button - Shows all investments
                    NavigationLink(
                        destination: PurchaseCatalogViewWrapper(),
                        tag: InvestmentType.catalog,
                        selection: $selectedInvestmentType
                    ) {
                        MenuCard(
                            title: "Investment Catalog",
                            description: "Browse all available investments",
                            icon: "square.grid.2x2.fill",
                            color: SwiftUI.Color.purple
                        )
                    }
                    
                    // Investment Funds Button
                    NavigationLink(
                        destination: PurchaseWelcomeViewWrapper(productId: "1", productTypeId: "1"),
                        tag: InvestmentType.investmentFunds,
                        selection: $selectedInvestmentType
                    ) {
                        MenuCard(
                            title: "Investment Funds",
                            description: "Browse and invest in investment funds",
                            icon: "chart.line.uptrend.xyaxis",
                            color: SwiftUI.Color.blue
                        )
                    }
                    
                    // Royalties Investment Button
                    NavigationLink(
                        destination: PurchaseWelcomeViewWrapper(productId: "2", productTypeId: "2"),
                        tag: InvestmentType.royaltiesInvestment,
                        selection: $selectedInvestmentType
                    ) {
                        MenuCard(
                            title: "Royalties Investment",
                            description: "Browse and invest in royalties",
                            icon: "doc.text.fill",
                            color: SwiftUI.Color.green
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MenuCard: View {
    let title: String
    let description: String
    let icon: String
    let color: SwiftUI.Color
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(color)
                .cornerRadius(12)
            
            // Text Content
            VStack(alignment: .leading, spacing: 4) {
                SwiftUI.Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                SwiftUI.Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Arrow
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding(20)
        .background(SwiftUI.Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: SwiftUI.Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    DashboardView()
}

