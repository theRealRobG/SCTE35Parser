//
//  UnexpectedEndOfDataErrorInfo+stub.swift
//  
//
//  Created by Robert Galluccio on 06/02/2021.
//

@testable import SCTE35Parser

extension UnexpectedEndOfDataErrorInfo {
    static func stub(
        expectedMinimumBitsLeft: Int = 1,
        actualBitsLeft: Int = 0,
        description: String = "Mock; parsing mock"
    ) -> UnexpectedEndOfDataErrorInfo {
        UnexpectedEndOfDataErrorInfo(
            expectedMinimumBitsLeft: expectedMinimumBitsLeft,
            actualBitsLeft: actualBitsLeft,
            description: description
        )
    }
}
