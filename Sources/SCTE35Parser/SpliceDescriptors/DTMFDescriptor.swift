//
//  DTMFDescriptor.swift
//  
//
//  Created by Robert Galluccio on 30/01/2021.
//

/// The `DTMFDescriptor` is an implementation of a `SpliceDescriptor`. It provides an optional extension
/// to the `SpliceInsert` command that allows a receiver device to generate a legacy analogue DTMF
/// sequence based on a `SpliceInfoSection` being received.
/**
 ```
 DTMF_descriptor() {
   splice_descriptor_tag          8 uimsbf
   descriptor_length              8 uimsbf
   identifier                    32 uimsbf
   preroll                        8 uimsbf
   dtmf_count                     3 uimsbf
   reserved                       5 bslbf
   for(i=0; i<dtmf_count; i++) {
     DTMF_char                    8 uimsbf
   }
 }
 ```
 */
public struct DTMFDescriptor: Equatable {
    /// This 32-bit number is used to identify the owner of the descriptor. The identifier shall have a
    /// value of 0x43554549 (ASCII "CUEI").
    public let identifier: UInt32
    /// This 8-bit number is the time the DTMF is presented to the analogue output of the device in
    /// tenths of seconds. This gives a preroll range of 0 to 25.5 seconds. The splice info section shall
    /// be sent at least two seconds earlier then this value. The minimum suggested preroll is 4.0
    /// seconds.
    public let preroll: UInt8
    /// This is a string of ASCII values from the numerals `0` to `9`, `*`, `#`. The string represents a
    /// DTMF sequence to be output on an analogue output. The string shall complete with the last
    /// character sent being the timing mark for the `preroll`.
    public let dtmfChars: String
    
    public init(
        identifier: UInt32,
        preroll: UInt8,
        dtmfChars: String
    ) {
        self.identifier = identifier
        self.preroll = preroll
        self.dtmfChars = dtmfChars
    }
}

// MARK: - Parsing

extension DTMFDescriptor {
    // NOTE: It is assumed that the splice_descriptor_tag has already been read.
    init(bitReader: DataBitReader) throws {
        let descriptorLength = bitReader.byte()
        let bitsReadBeforeDescriptor = bitReader.bitsRead
        let expectedBitsReadAtEndOfDescriptor = bitReader.bitsRead + (Int(descriptorLength) * 8)
        self.identifier = bitReader.uint32(fromBits: 32)
        self.preroll = bitReader.byte()
        let dtmfCount = bitReader.byte(fromBits: 3)
        _ = bitReader.bits(count: 5)
        self.dtmfChars = bitReader.string(fromBytes: UInt(dtmfCount))
        if bitReader.bitsRead != expectedBitsReadAtEndOfDescriptor {
            bitReader.nonFatalErrors.append(
                .unexpectedSpliceDescriptorLength(
                    UnexpectedSpliceDescriptorLengthErrorInfo(
                        declaredSpliceDescriptorLengthInBits: (Int(descriptorLength) * 8),
                        actualSpliceDescriptorLengthInBits: bitReader.bitsRead - bitsReadBeforeDescriptor,
                        spliceDescriptorTag: .dtmfDescriptor
                    )
                )
            )
        }
    }
}
