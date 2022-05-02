//
//  FinancialJournalApp.swift
//  FinancialJournal
//
//  Created by Nikita Nikitin on 09.04.2022.
//

import SwiftUI

@main
struct FinancialJournalApp: App {
    
    @State var coordinator = FnsMainTabCoordinator()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                FnsMainTabCoordinatorView(coordinator: coordinator)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
