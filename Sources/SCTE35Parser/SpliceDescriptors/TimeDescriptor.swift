//
//  TimeDescriptor.swift
//  
//
//  Created by Robert Galluccio on 04/02/2021.
//

/// The `TimeDescriptor` is an implementation of a `SpliceDescriptor`. It provides an optional extension
/// to the `SpliceInsert`, `SpliceNull` and `TimeSignal` commands that allows a programmer’s wall clock
/// time to be sent to a client. For the highest accuracy, this descriptor should be used with a
/// `TimeSignal` or `SpliceInsert` command that has a `ptsTime` defined.
/// The repetition rate of this descriptor should be at least once every 5 seconds. When it is the only
/// descriptor present in the `TimeSignal` or `SpliceNull` command, then the encoder should not insert a
/// key frame.
/// This command may be used to synchronize time based external metadata with video and the party
/// responsible for the metadata and the time value used should ensure that they are properly
/// synchronized and have the desired level of accuracy required for their application.
///
/// The `TimeDescriptor` uses the time format defined for the Precision Time Protocol [PTP]. [PTP] is
/// based upon an international time scale called International Atomic Time (TAI), unlike NTP [RFC5905]
/// which is based upon UTC. [PTP] is being used in a/v bridging and broadcast synchronization protocols
/// and likely to be available in a studio environment. Other time sources, such as NTP or GPS, are
/// readily convertible to PTP format.
///
/// TAI does not have "leap" seconds like UTC. When UTC was introduced (January 1, 1972) it was
/// determined there should be a difference of 10 seconds between the two time scales. Since then an
/// additional 27 leap seconds (including one in December 2016) have been added to UTC to put the current
/// difference between the two timescales at 37 seconds (as of June 2018) The [PTP] protocol communicates
/// the current offset between TAI and UTC to enable conversion. By default [PTP] uses the same "epoch"
/// (i.e. origination or reference start time and date of the timescale) as Unix time, of 00:00, January
/// 1, 1970. Readers are advised to consult IERS Bulletin C for the current value of leap seconds
/// [https://www.iers.org/IERS/EN/Publications/Bulletins/bulletins.html].
/**
 ```
 {
   splice_descriptor_tag  8 uimsbf
   descriptor_length      8 uimsbf
   identifier            32 uimsbf
   TAI_seconds           48 uimsbf
   TAI_ns                32 uimsbf
   UTC_offset            16 uimsbf
 }
 ```
 */
public struct TimeDescriptor: Equatable {
    /// This 32-bit number is used to identify the owner of the descriptor. The identifier shall have a
    /// value of 0x43554549 (ASCII “CUEI”).
    public let identifier: UInt32
    /// This 48-bit number is the TAI seconds value.
    public let taiSeconds: UInt64
    /// This 32-bit number is the TAI nanoseconds value.
    public let taiNS: UInt32
    /// This 16-bit number shall be used in the conversion from TAI time to UTC or NTP time per the
    /// following equations.
    /// ```
    /// UTC seconds = TAI seconds - UTC_offset
    /// NTP seconds = TAI seconds - UTC_offset + 2,208,988,800
    /// ```
    public let utcOffset: UInt16
    
    public init(
        identifier: UInt32,
        taiSeconds: UInt64,
        taiNS: UInt32,
        utcOffset: UInt16
    ) {
        self.identifier = identifier
        self.taiSeconds = taiSeconds
        self.taiNS = taiNS
        self.utcOffset = utcOffset
    }
}

// MARK: - Parsing

extension TimeDescriptor {
    // NOTE: It is assumed that the splice_descriptor_tag has already been read.
    init(bitReader: DataBitReader) throws {
        let descriptorLength = bitReader.byte()
        let bitsReadBeforeDescriptor = bitReader.bitsRead
        let expectedBitsReadAtEndOfDescriptor = bitReader.bitsRead + (Int(descriptorLength) * 8)
        self.identifier = bitReader.uint32(fromBits: 32)
        self.taiSeconds = bitReader.uint64(fromBits: 48)
        self.taiNS = bitReader.uint32(fromBits: 32)
        self.utcOffset = bitReader.uint16(fromBits: 16)
        if bitReader.bitsRead != expectedBitsReadAtEndOfDescriptor {
            bitReader.nonFatalErrors.append(
                .unexpectedSpliceDescriptorLength(
                    UnexpectedSpliceDescriptorLengthErrorInfo(
                        declaredSpliceDescriptorLengthInBits: (Int(descriptorLength) * 8),
                        actualSpliceDescriptorLengthInBits: bitReader.bitsRead - bitsReadBeforeDescriptor,
                        spliceDescriptorTag: .timeDescriptor
                    )
                )
            )
        }
    }
}
