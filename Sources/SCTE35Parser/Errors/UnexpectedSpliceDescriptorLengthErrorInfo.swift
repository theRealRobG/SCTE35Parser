//
//  UnexpectedSpliceDescriptorLengthErrorInfo.swift
//  
//
//  Created by Robert Galluccio on 02/05/2021.
//

public struct UnexpectedSpliceDescriptorLengthErrorInfo: Equatable {
    /// This is the number of bits that the `SpliceDescriptor` was expected to have as declared via `descriptor_length`.
    public let declaredSpliceDescriptorLengthInBits: Int
    /// This is the number of bits that the `SpliceDescriptor` actually had after parsing had completed.
    public let actualSpliceDescriptorLengthInBits: Int
    /// The tag for the splice descriptor.
    public let spliceDescriptorTag: SpliceDescriptorTag
    
    public init(
        declaredSpliceDescriptorLengthInBits: Int,
        actualSpliceDescriptorLengthInBits: Int,
        spliceDescriptorTag: SpliceDescriptorTag
    ) {
        self.declaredSpliceDescriptorLengthInBits = declaredSpliceDescriptorLengthInBits
        self.actualSpliceDescriptorLengthInBits = actualSpliceDescriptorLengthInBits
        self.spliceDescriptorTag = spliceDescriptorTag
    }
}
