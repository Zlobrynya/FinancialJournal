//
//  SessionData.swift
//  FinancialJournal
//
//  Created by Nikita Nikitin on 23.04.2022.
//

import Foundation

struct SessionData: Decodable {
    enum CodingKeys: String, CodingKey {
        case sessionId
        case refreshToken = "refresh_token"
    }

    let sessionId: String
    let refreshToken: String
}
