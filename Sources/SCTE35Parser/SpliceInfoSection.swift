//
//  SpliceInfoSection.swift
//  
//
//  Created by Robert Galluccio on 06/02/2021.
//

import Foundation

/**
 ```
 {
   table_id                         8 uimsbf
   section_syntax_indicator         1 bslbf
   private_indicator                1 bslbf
   sap_type                         2 bslbf
   section_length                  12 uimsbf
   protocol_version                 8 uimsbf
   encrypted_packet                 1 bslbf
   encryption_algorithm             6 uimsbf
   pts_adjustment                  33 uimsbf
   cw_index                         8 uimsbf
   tier                            12 bslbf
   splice_command_length           12 uimsbf
   splice_command_type              8 uimsbf E
   if(splice_command_type == 0x00)
     splice_null()                           E
   if(splice_command_type == 0x04)
     splice_schedule()                       E
   if(splice_command_type == 0x05)
     splice_insert()                         E
   if(splice_command_type == 0x06)
     time_signal()                           E
   if(splice_command_type == 0x07)
     bandwidth_reservation()                 E
   if(splice_command_type == 0xff)
     private_command()                       E
   descriptor_loop_length          16 uimsbf E
   for(i=0; i<N1; i++)
     splice_descriptor()                     E
   for(i=0; i<N2; i++)
     alignment_stuffing             8 bslbf  E
   if(encrypted_packet)
     E_CRC_32                      32 rpchof E
   CRC_32                          32 rpchof
 }
 ```
 */

/// The `SpliceInfoSection` shall be carried in transport packets whereby only one section or partial
/// section may be in any transport packet. `SpliceInfoSection`s shall always start at the beginning of a
/// transport packet payload.
public struct SpliceInfoSection: Equatable {
    /// This is an 8-bit field. Its value shall be 0xFC.
    public let tableID: UInt8
    /// A two-bit field that indicates if the content preparation system has created a Stream Access
    /// Point (SAP) at the signaled point in the stream. SAP types are defined in ISO 14496-12, Annex I.
    public let sapType: SAPType
    /// An 8-bit unsigned integer field whose function is to allow, in the future, this table type to
    /// carry parameters that may be structured differently than those defined in the current protocol.
    /// At present, the only valid value for `protocolVersion` is zero. Non-zero values of
    /// `protocolVersion` may be used by a future version of this standard to indicate structurally
    /// different tables.
    public let protocolVersion: UInt8
    /// When this is set, it indicates that portions of the `SpliceInfoSection`, starting with
    /// `spliceCommandType` and ending with and including `E_CRC_32`, are encrypted. When this is not
    /// set, no part of this message is encrypted. The potentially encrypted portions of the
    /// `SpliceInfoTable` are indicated by an `E` in the Encrypted column of Table 5 (included in the
    /// doc-string for this `struct`).
    public let encryptedPacket: EncryptedPacket?
    /// A 33-bit unsigned integer that appears in the clear and that shall be used by a splicing device
    /// as an offset to be added to the (sometimes) encrypted `ptsTime` field(s) throughout this message,
    /// to obtain the intended splice time(s). When this field has a zero value, then the `ptsTime`
    /// field(s) shall be used without an offset. Normally, the creator of a cueing message will place a
    /// zero value into this field. This adjustment value is the means by which an upstream device, which
    /// restamps PCR/PTS/DTS, may convey to the splicing device the means by which to convert the
    /// `ptsTime` field of the message to a newly imposed time domain.
    ///
    /// It is intended that the first device that restamps PCR/PTS/DTS and that passes the cueing message
    /// will insert a value into the `ptsAdjustment` field, which is the delta time between this device’s
    /// input time domain and its output time domain. All subsequent devices, which also restamp
    /// PCR/PTS/DTS, may further alter the `ptsAdjustment` field by adding their delta time to the
    /// field’s existing delta time and placing the result back in the `ptsAdjustment` field. Upon each
    /// alteration of the `ptsAdjustment` field, the altering device shall recalculate and update the
    /// `CRC_32` field.
    ///
    /// The `ptsAdjustment` shall, at all times, be the proper value to use for conversion of the
    /// `ptsTime` field to the current time-base. The conversion is done by adding the two fields. In the
    /// presence of a wrap or overflow condition, the carry shall be ignored.
    public let ptsAdjustment: UInt64
    /// A 12-bit value used by the SCTE 35 message provider to assign messages to authorization tiers.
    /// This field may take any value between 0x000 and 0xFFF. The value of 0xFFF provides backwards
    /// compatibility and shall be ignored by downstream equipment. When using tier, the message provider
    /// should keep the entire message in a single transport stream packet.
    public let tier: UInt16
    /// Information on the intention of this `SpliceInfoSection`.
    public let spliceCommand: SpliceCommand
    /// Further descriptors in addition to the `spliceCommand`.
    public let spliceDescriptors: [SpliceDescriptor]
    /// This is a 32-bit field that contains the CRC value that gives a zero output of the registers in
    /// the decoder defined in [MPEG Systems]after processing the entire `SpliceInfoSection`, which
    /// includes the `tableID` field through the `CRC_32` field. The processing of `CRC_32` shall occur
    /// prior to decryption of the encrypted fields and shall utilize the encrypted fields in their
    /// encrypted state.
    public let CRC_32: UInt32
    /// A list of errors that have not caused the message to be un-parsable, but are inconsistent with the
    /// specification. An example of this could be a splice command who's computed length after parsing did
    /// not match the indicated length of the command.
    public let nonFatalErrors: [ParserError]
    
    public init(
        tableID: UInt8,
        sapType: SAPType,
        protocolVersion: UInt8,
        encryptedPacket: EncryptedPacket?,
        ptsAdjustment: UInt64,
        tier: UInt16,
        spliceCommand: SpliceCommand,
        spliceDescriptors: [SpliceDescriptor],
        CRC_32: UInt32,
        nonFatalErrors: [ParserError] = []
    ) {
        self.tableID = tableID
        self.sapType = sapType
        self.protocolVersion = protocolVersion
        self.encryptedPacket = encryptedPacket
        self.ptsAdjustment = ptsAdjustment
        self.tier = tier
        self.spliceCommand = spliceCommand
        self.spliceDescriptors = spliceDescriptors
        self.CRC_32 = CRC_32
        self.nonFatalErrors = nonFatalErrors
    }
    
    /// Creates a `SpliceInfoSection` using the provided base64 encoded string.
    /// - Parameter base64String: A string of base64 encoded SCTE-35 data.
    /// - Throws: `SCTE35ParserError`
    public init(base64String: String) throws {
        guard let data = Data(base64Encoded: base64String) else {
            throw ParserError.invalidInputString(base64String)
        }
        try self.init(data: data)
    }
    
    /// Creates a `SpliceInfoSection` using the provided hex encoded string.
    /// - Parameter hexString: A string of hex encoded SCTE-35 data.
    /// - Throws: `SCTE35ParserError`
    public init(hexString: String) throws {
        guard let data = Data(hexString: hexString) else {
            throw ParserError.invalidInputString(hexString)
        }
        try self.init(data: data)
    }
    
    /// Creates a `SpliceInfoSection` using the provided string formatted data.
    /// - Parameter string: Should either be base64 encoded or hex encoded SCTE-35 data. The check will determine if the
    /// string "looks hex" by checking that it has a `0x` prefix, and assuming that attempt to convert to `Data` using hex format first
    /// and failing that trying with `Data.init?(base64Encoded base64String: String)` (and vice-versa where the string
    /// does not "look hex").
    /// - Throws: `SCTE35ParserError`
    public init(_ string: String) throws {
        let looksHex = string.hasPrefix("0x")
        if looksHex {
            guard let data = Data(hexString: string) ?? Data(base64Encoded: string) else {
                throw ParserError.invalidInputString(string)
            }
            try self.init(data: data)
        } else {
            guard let data = Data(base64Encoded: string) ?? Data(hexString: string) else {
                throw ParserError.invalidInputString(string)
            }
            try self.init(data: data)
        }
    }
}

public extension SpliceInfoSection {
    /// A two-bit field that indicates if the content preparation system has created a Stream Access
    /// Point (SAP) at the signaled point in the stream. SAP types are defined in ISO 14496-12, Annex I.
    enum SAPType: UInt8 {
        /// Closed GOP with no leading pictures
        case type1 = 0x0
        /// Closed GOP with leading pictures
        case type2 = 0x1
        /// Open GOP
        case type3 = 0x2
        /// The type of SAP, if any, is not signaled
        case unspecified = 0x3
    }
}

public extension SpliceInfoSection {
    /// This indicates that portions of the `SpliceInfoSection`, starting with `spliceCommandType` and
    /// ending with and including `E_CRC_32`, are encrypted.
    struct EncryptedPacket: Equatable {
        /// The `encryptionAlgorithm` field of the `SpliceInfoSection` is a 6-bit value. All Data Encryption Standard
        /// variants use a 64-bit key (actually 56 bits plus a checksum) to encrypt or decrypt a block of 8 bytes. In the
        /// case of triple DES, there will need to be 3 64-bit keys, one for each of the three passes of the DES
        /// algorithm. The “standard” triple DES actually uses two keys, where the first and third keys are identical.
        public let encryptionAlgorithm: EncryptionAlgorithm?
        /// An 8-bit unsigned integer that conveys which control word (key) is to be used to decrypt the
        /// message. The splicing device may store up to 256 keys previously provided for this purpose.
        /// When the `encryptedPacket` is `false`, this field is present but undefined.
        public let cwIndex: UInt8
        /// When encryption is used, this field is a function of the particular encryption algorithm
        /// chosen. Since some encryption algorithms require a specific length for the encrypted data, it
        /// is necessary to allow the insertion of stuffing bytes. For example, DES requires a multiple
        /// of 8 bytes be present in order to encrypt to the end of the packet. This allows standard DES
        /// to be used, as opposed to requiring a special version of the encryption algorithm.
        public let alignmentStuffing: UInt8
        /// This is a 32-bit field that contains the CRC value that gives a zero output of the registers
        /// in the decoder defined in [MPEG Systems] after processing the entire decrypted portion of the
        /// `SpliceInfoSection`. This field is intended to give an indication that the decryption was
        /// performed successfully. Hence, the zero output is obtained following decryption and by
        /// processing the fields `SpliceCommandType` through `E_CRC_32`.
        public let E_CRC_32: UInt32
        
        public init(
            encryptionAlgorithm: EncryptionAlgorithm?,
            cwIndex: UInt8,
            alignmentStuffing: UInt8,
            E_CRC_32: UInt32
        ) {
            self.encryptionAlgorithm = encryptionAlgorithm
            self.cwIndex = cwIndex
            self.alignmentStuffing = alignmentStuffing
            self.E_CRC_32 = E_CRC_32
        }
    }
}

public extension SpliceInfoSection.EncryptedPacket {
    /// The `encryptionAlgorithm` field of the `SpliceInfoSection` is a 6-bit value. All Data Encryption Standard
    /// variants use a 64-bit key (actually 56 bits plus a checksum) to encrypt or decrypt a block of 8 bytes. In the
    /// case of triple DES, there will need to be 3 64-bit keys, one for each of the three passes of the DES
    /// algorithm. The “standard” triple DES actually uses two keys, where the first and third keys are identical.
    enum EncryptionAlgorithm: Equatable {
        /// No encryption
        case noEncryption
        /// DES - ECB Mode
        case desECBMode
        /// DES - CBC Mode
        case desCBCMode
        /// Triple DES EDE3 - ECB Mode
        case tripleDES
        /// User private
        case userPrivate(UInt8)
        
        init?(_ value: UInt8) {
            if value == 0 { self = .noEncryption }
            else if value == 1 { self = .desECBMode }
            else if value == 2 { self = .desCBCMode }
            else if value == 3 { self = .tripleDES }
            else if value >= 4, value <= 31 { return nil }
            else if value >= 32, value <= 63 { self = .userPrivate(value) }
            else { return nil }
        }
    }
}

// MARK: - Parsing

public extension SpliceInfoSection {
    /// Creates a `SpliceInfoSection` from the provided `Data`.
    /// - Parameter data: `Data` representing SCTE-35 information.
    /// - Throws: `SCTE35ParserError`
    init(data: Data) throws {
        let bitReader = DataReader(data: data)
        do {
            try bitReader.validate(
                expectedMinimumBitsLeft: 24,
                parseDescription: "SpliceInfoSection; need at least 24 bits to get to end of section_length field"
            )
            self.tableID = try bitReader.byte()
            guard try bitReader.bit() == 0 else { throw ParserError.invalidSectionSyntaxIndicator }
            guard try bitReader.bit() == 0 else { throw ParserError.invalidPrivateIndicator }
            self.sapType = SAPType(rawValue: try bitReader.byte(fromBits: 2)) ?? .unspecified
            let sectionLengthInBytes = try bitReader.int(fromBits: 12)
            try bitReader.validate(
                expectedMinimumBitsLeft: sectionLengthInBytes * 8,
                parseDescription: "SpliceInfoSection; section_length defined as \(sectionLengthInBytes)"
            )
            self.protocolVersion = try bitReader.byte()
            let isEncrypted = try bitReader.bit() == 1
            if isEncrypted {
                throw ParserError.encryptedMessageNotSupported
            }
            let _ /* encryptionAlgorithm */ = EncryptedPacket.EncryptionAlgorithm(try bitReader.byte(fromBits: 6))
            self.ptsAdjustment = try bitReader.uint64(fromBits: 33)
            let _ /* cwIndex */ = try bitReader.byte()
            self.tier = try bitReader.uint16(fromBits: 12)
            let spliceCommandLength = try bitReader.int(fromBits: 12)
            self.spliceCommand = try SpliceCommand(bitReader: bitReader, spliceCommandLength: spliceCommandLength)
            let descriptorLoopLength = try bitReader.int(fromBits: 16)
            self.spliceDescriptors = try [SpliceDescriptor].init(bitReader: bitReader, descriptorLoopLength: descriptorLoopLength)
            if isEncrypted {
                throw ParserError.encryptedMessageNotSupported
            } else {
                self.encryptedPacket = nil
                while bitReader.bitsLeft >= 40 {
                    _ = try bitReader.byte()
                }
            }
            self.CRC_32 = try bitReader.uint32(fromBits: 32)
            self.nonFatalErrors = bitReader.nonFatalErrors
        } catch {
            guard let parserError = error as? ParserError else { throw error }
            throw SCTE35ParserError(error: parserError, underlyingError: bitReader.nonFatalErrors.first)
        }
    }
}
