//
//  TestExpectation.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 02/11/23.
//

import Foundation
import XCTest

class TestExpectation: XCTestExpectation {
    private(set) var currentFulfillmentCount = 0

    override func fulfill() {
        super.fulfill()
        currentFulfillmentCount += 1
    }
}
