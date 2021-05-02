//
//  TimeSignal.swift
//  
//
//  Created by Robert Galluccio on 30/01/2021.
//

/// The `TimeSignal` provides a time synchronized data delivery mechanism. The syntax of the `TimeSignal`
/// allows for the synchronization of the information carried in this message with the system time clock
/// (STC). The unique payload of the message is carried in the descriptor, however the syntax and
/// transport capabilities afforded to `SpliceInsert` messages are also afforded to the `TimeSignal`. The
/// carriage however can be in a different PID than that carrying the other cue messages used for
/// signalling splice points.
/// If there is no `ptsTime` in the message, then the command shall be interpreted as an immediate
/// command. It must be understood that using it in this manner will cause an unspecified amount of
/// accuracy error.
/**
 ```
 time_signal() {
   splice_time()
 }
 ```
 */
public struct TimeSignal: Equatable {
    /// The `SpliceTime` structure, when modified by `ptsAdjustment`, specifies the time of the
    /// splice event.
    public let spliceTime: SpliceTime
    /// When there is no `ptsTime` in the message, then the command shall be interpreted as an immediate
    /// command. It must be understood that using it in this manner will cause an unspecified amount of
    /// accuracy error.
    ///
    /// In this specific case, this is a computed property, that is `true` when
    /// `spliceTime.ptsTime == nil`
    public var isImmediate: Bool { spliceTime.ptsTime == nil }
    
    public init(spliceTime: SpliceTime) {
        self.spliceTime = spliceTime
    }
}

// MARK: - Parsing

extension TimeSignal {
    init(bitReader: DataBitReader) throws {
        self.spliceTime = try SpliceTime(bitReader: bitReader)
    }
}
