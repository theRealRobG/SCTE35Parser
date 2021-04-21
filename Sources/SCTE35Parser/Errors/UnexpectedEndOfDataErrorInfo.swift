//
//  UnexpectedEndOfDataErrorInfo.swift
//  
//
//  Created by Robert Galluccio on 06/02/2021.
//

public struct UnexpectedEndOfDataErrorInfo: Equatable {
    /// The expected minimum number of bits left in the data.
    public let expectedMinimumBitsLeft: Int
    /// The actual number of bits left in the data.
    public let actualBitsLeft: Int
    /// A description of what was being attempted to be parsed that resulted in error.
    public let description: String
    
    public init(
        expectedMinimumBitsLeft: Int,
        actualBitsLeft: Int,
        description: String
    ) {
        self.expectedMinimumBitsLeft = expectedMinimumBitsLeft
        self.actualBitsLeft = actualBitsLeft
        self.description = description
    }
}
