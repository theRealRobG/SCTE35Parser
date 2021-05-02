//
//  UnexpectedSpliceCommandLengthErrorInfo.swift
//  
//
//  Created by Robert Galluccio on 02/05/2021.
//

public struct UnexpectedSpliceCommandLengthErrorInfo: Equatable {
    /// This is the number of bits that the SpliceCommand was expected to have as declared via
    /// `splice_command_length`.
    public let declaredSpliceCommandLengthInBits: Int
    /// This is the number of bits that the SpliceCommand actually had after parsing had completed.
    public let actualSpliceCommandLengthInBits: Int
    
    public init(
        declaredSpliceCommandLengthInBits: Int,
        actualSpliceCommandLengthInBits: Int
    ) {
        self.declaredSpliceCommandLengthInBits = declaredSpliceCommandLengthInBits
        self.actualSpliceCommandLengthInBits = actualSpliceCommandLengthInBits
    }
}
