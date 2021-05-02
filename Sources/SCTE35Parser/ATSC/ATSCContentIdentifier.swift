//
//  ATSCContentIdentifier.swift
//  
//
//  Created by Robert Galluccio on 31/03/2021.
//

/// The ATSC Content Identifier is a structure that is composed of a TSID and a “house number”
/// with a period of uniqueness. A “house number” is any number that the holder of the TSID
/// wishes as constrained herein. Numbers are unique for each value of TSID.
/**
 ```
 {
   TSID       16 uimsbf
   reserved    2 bslbf
   end_of_day  5 uimsbf
   unique_for  9 uimsbf
   content_id
 }
 ```
 */
public struct ATSCContentIdentifier: Equatable {
    /// This 16 bit unsigned integer field shall contain a value of `transport_stream_id` per
    /// section 6.3.1 of A/65 [3]. Note: The assigning authority for these values for the United
    /// States is the FCC. Ranges for Mexico, Canada, and the United States have been
    /// established by formal agreement among these countries. Values in other regions are
    /// established by appropriate authorities.
    public let tsid: UInt16
    /// This 5-bit unsigned integer shall be set to the hour of the day in UTC in which the
    /// broadcast day ends and the instant after which the `contentID` values may be re-used
    /// according to `uniqueFor`. The value of this field shall be in the range of 0–23. The
    /// values 24–31 are reserved. Note that the value of this field is expected to be static
    /// per broadcaster.
    public let endOfDay: UInt8
    /// This 9-bit unsigned integer shall be set to the number of days, rounded up, measured
    /// relative to the hour indicated by `endOfDay`, during which the `contentID` value is not
    /// reassigned to different content. The value shall be in the range 1 to 511. The value
    /// zero shall be forbidden. The value 511 shall have the special meaning of “indefinitely”.
    /// Note that the value of this field is expected to be essentially static per broadcaster,
    /// only changing when the method of house numbering is changed. Note also that decoders can
    /// treat stored `contentID` values as unique until the `uniqueFor` fields expire, which can
    /// be implemented by decrementing all stored `uniqueFor` fields by one every day at the
    /// `endOfDay` until they reach zero.
    public let uniqueFor: UInt16
    /// This variable length field shall be set to the value of the identifier according to the
    /// house number system or systems for the value of `tsid`. Each such value shall not be
    /// assigned to different content within the period of uniqueness set by the values in the
    /// `endOfDay` and `uniqueFor` fields. The identifier may be any combination of human
    /// readable and/or binary values and need not exactly match the form of a house number, not
    /// to exceed 242 bytes.
    public let contentID: String
    
    public init(
        tsid: UInt16,
        endOfDay: UInt8,
        uniqueFor: UInt16,
        contentID: String
    ) {
        self.tsid = tsid
        self.endOfDay = endOfDay
        self.uniqueFor = uniqueFor
        self.contentID = contentID
    }
}

// MARK: - Parsing

extension ATSCContentIdentifier {
    init(bitReader: DataBitReader, upidLength: UInt8) throws {
        let contentIDLength = Int(upidLength) - 4
        guard contentIDLength >= 0 else {
            throw ParserError.invalidATSCContentIdentifierInUPID(
                InvalidATSCContentIdentifierInUPIDInfo(upidLength: Int(upidLength))
            )
        }
        self.tsid = bitReader.uint16(fromBits: 16)
        _ = bitReader.bits(count: 2)
        self.endOfDay = bitReader.byte(fromBits: 5)
        self.uniqueFor = bitReader.uint16(fromBits: 9)
        self.contentID = bitReader.string(fromBytes: UInt(contentIDLength))
    }
}
