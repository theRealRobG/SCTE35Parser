//
//  AvailDescriptor.swift
//  
//
//  Created by Robert Galluccio on 30/01/2021.
//

/// The `AvailDescriptor` is an implementation of a `SpliceDescriptor`. It provides an optional extension
/// to the `SpliceInsert` command that allows an authorization identifier to be sent for an avail.
/// Multiple copies of this descriptor may be included by using the loop mechanism provided. This
/// identifier is intended to replicate the functionality of the cue tone system used in analogue systems
/// for ad insertion. This descriptor is intended only for use with a `SpliceInsert` command, within a
/// `SpliceInfoSection`.
/**
 ```
 avail_descriptor() {
   splice_descriptor_tag  8 uimsbf
   descriptor_length      8 uimsbf
   identifier            32 uimsbf
   provider_avail_id     32 uimsbf
 }
 ```
 */
public struct AvailDescriptor: Equatable {
    /// This 32-bit number is used to identify the owner of the descriptor. The identifier shall have a
    /// value of 0x43554549 (ASCII "CUEI").
    public let identifier: UInt32
    /// This 32-bit number provides information that a receiving device may utilize to alter its
    /// behaviour during or outside of an avail. It may be used in a manner similar to analogue cue
    /// tones. An example would be a network directing an affiliate or a head-end to black out a sporting
    /// event.
    public let providerAvailId: UInt32
    
    public init(
        identifier: UInt32,
        providerAvailId: UInt32
    ) {
        self.identifier = identifier
        self.providerAvailId = providerAvailId
    }
}

// MARK: - Parsing

extension AvailDescriptor {
    // NOTE: It is assumed that the splice_descriptor_tag has already been read.
    init(bitReader: DataBitReader) throws {
        let descriptorLength = bitReader.byte()
        let bitsReadBeforeDescriptor = bitReader.bitsRead
        let expectedBitsReadAtEndOfDescriptor = bitReader.bitsRead + (Int(descriptorLength) * 8)
        self.identifier = bitReader.uint32(fromBits: 32)
        self.providerAvailId = bitReader.uint32(fromBits: 32)
        if bitReader.bitsRead != expectedBitsReadAtEndOfDescriptor {
            bitReader.nonFatalErrors.append(
                .unexpectedSpliceDescriptorLength(
                    UnexpectedSpliceDescriptorLengthErrorInfo(
                        declaredSpliceDescriptorLengthInBits: (Int(descriptorLength) * 8),
                        actualSpliceDescriptorLengthInBits: bitReader.bitsRead - bitsReadBeforeDescriptor,
                        spliceDescriptorTag: .availDescriptor
                    )
                )
            )
        }
    }
}
