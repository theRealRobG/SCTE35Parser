//
//  UnexpectedDescriptorLoopLengthErrorInfo.swift
//  
//
//  Created by Robert Galluccio on 02/05/2021.
//

public struct UnexpectedDescriptorLoopLengthErrorInfo: Equatable {
    /// This is the number of bits that the `SpliceDescriptor` array was expected to have as declared via
    /// `descriptor_loop_length`.
    public let declaredDescriptorLoopLengthInBits: Int
    /// This is the number of bits that the `SpliceDescriptor` array actually had after parsing had completed.
    public let actualDescriptorLoopLengthInBits: Int
    
    public init(
        declaredDescriptorLoopLengthInBits: Int,
        actualDescriptorLoopLengthInBits: Int
    ) {
        self.declaredDescriptorLoopLengthInBits = declaredDescriptorLoopLengthInBits
        self.actualDescriptorLoopLengthInBits = actualDescriptorLoopLengthInBits
    }
}
