//
//  Api.swift
//  FinancialJournal
//
//  Created by Nikita Nikitin on 23.04.2022.
//

import NetworkFramework

extension Api {
    static let headers: Headers = {
        [
            "Content-type": "application/json",
            "Accept": "*/*",
            "Device-OS": "iOS",
            "Device-Id": "D1FFF188-F169-418F-B7D1-B46DD89D0602",
            "clientVersion": "2.24.0",
            "Accept-Language": "ru-RU;q=1, en-US;q=0.9",
            "User-Agent": "Proverka ceka/2.24.0 (iPhone; iOS 15.3.1; Scale/3.00)",
        ]
    }()
}
