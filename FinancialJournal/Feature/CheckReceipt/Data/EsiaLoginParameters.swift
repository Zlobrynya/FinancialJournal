//
//  EsiaLoginParameters.swift
//  FinancialJournal
//
//  Created by Nikita Nikitin on 23.04.2022.
//

import NetworkFramework

struct EsiaLoginParameters: RequestParametersProtocol {
    static var caseType: CaseTypes = .snakeCase
    
    let authorizationCode: String
    let timestamp: String
    let state: String
    let clientSecret: String
}
