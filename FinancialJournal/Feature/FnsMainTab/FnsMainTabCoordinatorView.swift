//
//  FnsMainTabCoordinatorView.swift
//  FinancialJournal
//
//  Created by Nikita Nikitin on 02.05.2022.
//

import SwiftUI

struct FnsMainTabCoordinatorView: View {
    @ObservedObject var coordinator: FnsMainTabCoordinator

    var body: some View {
        VStack {
            if let qrScannerViewModel = coordinator.qrScannerViewModel {
                QrScannerView(viewModel: qrScannerViewModel)
            }
        }
        .transition(.move(edge: .top))
        .fullScreenCover(item: $coordinator.loginFnsViewModel, content: { item in
            LoginFnsView(viewModel: item)
        })
    }
}

//struct FnsMainTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        FnsMainTabView()
//    }
//}
