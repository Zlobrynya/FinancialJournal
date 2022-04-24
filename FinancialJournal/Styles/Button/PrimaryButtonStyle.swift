//
//  PrimaryButtonStyle.swift
//  FinancialJournal
//
//  Created by Nikita Nikitin on 09.04.2022.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(8)
            .frame(minWidth: .zero, maxWidth: .infinity)
            .background(Colors.accentButton.color)
            .foregroundColor(Colors.primaryTextNegative.color)
            .cornerRadius(24)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .lineLimit(1)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {

    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
}
