//
//  CGADomainsModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 20/09/23.
//

import Foundation

struct CGADomainsModels {

    struct DomainViewModel {
        let name: String
        let symbol: String
        let tests: [Test]
    }

    struct Test {
        let name: String
        let isDone: Bool
    }
}
