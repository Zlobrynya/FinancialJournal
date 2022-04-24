//
//  Url.swift
//  FinancialJournal
//
//  Created by Nikita Nikitin on 23.04.2022.
//

import Foundation

extension URL: Identifiable {
    public var id: String {
        absoluteString
    }
}
