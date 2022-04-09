//
//  LoginFns.swift
//  FinancialJournal
//
//  Created by Nikita Nikitin on 09.04.2022.
//

import SwiftUI

struct LoginFns: View {
    var body: some View {
        VStack(spacing: 16) {
            Asset.loginRecieptIcon.image
                .resizable()
            information
            Spacer()
            buttonEsia
        }
        .padding()
        .background(Colors.primaryBg.color)
    }
    
    private var information: some View {
        VStack(alignment: .leading, spacing: 11) {
            Text(Strings.LoginFns.title)
                .font(.boldOpenSans20)
                .multilineTextAlignment(.leading)
            Text(Strings.LoginFns.description)
                .font(.regularOpenSans14)
                .multilineTextAlignment(.leading)
        }.padding(.horizontal, 34)
    }
    
    private var buttonEsia: some View {
        Button(
            action: {},
            label: {
                Text(Strings.LoginFns.esia)
            }
        )
        .buttonStyle(.primary)
    }
}

struct LoginFns_Previews: PreviewProvider {
    static var previews: some View {
        LoginFns()
    }
}
