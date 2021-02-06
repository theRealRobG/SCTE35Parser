//
//  SpliceInfoSection.swift
//  
//
//  Created by Robert Galluccio on 06/02/2021.
//

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
public struct SpliceInfoSection {
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
    struct EncryptedPacket {
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
    }
}
