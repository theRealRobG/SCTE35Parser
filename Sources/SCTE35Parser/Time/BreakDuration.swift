//
//  BreakDuration.swift
//  
//
//  Created by Robert Galluccio on 30/01/2021.
//

/// The `BreakDuration` structure specifies the duration of the commercial break(s). It may
/// be used to give the splicer an indication of when the break will be over and when the
/// network in point will occur.
/**
 ```
 break_duration() {
   auto_return       1 bslbf
   reserved          6 bslbf
   duration         33 uimsbf
 }
 ```
 */
public struct BreakDuration: Equatable {
    /// A flag that, when set to `true`, denotes that the `duration` shall be used by
    /// the splicing device to know when the return to the network feed (end of break)
    /// is to take place. A `SpliceInsert` command with `outOfNetworkIndicator` set
    /// to `false` is not intended to be sent to end this break. When this flag is `false`,
    /// the `duration` field, if present, is not required to end the break because a new
    /// `SpliceInsert` command will be sent to end the break. In this case, the presence
    /// of the `BreakDuration` field acts as a safety mechanism in the event that a
    /// `SpliceInsert` command is lost at the end of a break.
    public let autoReturn: Bool
    /// A 33-bit field that indicates elapsed time in terms of ticks of the program's 90 kHz
    /// clock.
    public let duration: UInt64
    
    public init(
        autoReturn: Bool,
        duration: UInt64
    ) {
        self.autoReturn = autoReturn
        self.duration = duration
    }
}

// MARK: - Parsing

extension BreakDuration {
    init(bitReader: DataBitReader) throws {
        try bitReader.validate(
            expectedMinimumBitsLeft: 40,
            parseDescription: "BreakDuration"
        )
        autoReturn = bitReader.bit() == 1
        _ = bitReader.bits(count: 6)
        duration = bitReader.uint64(fromBits: 33)
    }
}
