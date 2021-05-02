//
//  SpliceSchedule.swift
//  
//
//  Created by Robert Galluccio on 30/01/2021.
//

/// The `SpliceSchedule` command is provided to allow a schedule of splice events to be conveyed
/// in advance.
/**
 ```
 splice_schedule() {
   splice_count                                   8 uimsbf
   for (i=0; i<splice_count; i++) {
     splice_event_id                             32 uimsbf
     splice_event_cancel_indicator                1 bslbf
     reserved                                     7 bslbf
     if (splice_event_cancel_indicator == '0') {
       out_of_network_indicator                   1 bslbf
       program_splice_flag                        1 bslbf
       duration_flag                              1 bslbf
       reserved                                   5 bslbf
       if (program_splice_flag == '1')
         utc_splice_time                         32 uimsbf
       if (program_splice_flag == '0') {
         component_count                          8 uimsbf
         for(j=0;j<component_count;j++) {
           component_tag                          8 uimsbf
           utc_splice_time                       32 uimsbf
         }
       }
       if (duration_flag)
         break_duration()
       unique_program_id                         16 uimsbf
       avail_num                                  8 uimsbf
       avails_expected                            8 uimsbf
     }
   }
 }
 ```
 */
public struct SpliceSchedule: Equatable {
    public let events: [SpliceSchedule.Event]
    
    public init(events: [SpliceSchedule.Event]) {
        self.events = events
    }
}

public extension SpliceSchedule {
    struct Event: Equatable {
        /// A 32-bit unique splice event identifier.
        public let eventId: UInt32
        /// Information on the scheduled event. If this value is `nil` it indicates that a previously
        /// sent splice event, identified by `eventId`, has been cancelled.
        public let scheduledEvent: ScheduledEvent?
        /// When set to `true` indicates that a previously sent splice event, identified by `eventId`,
        /// has been cancelled.
        public var isCancelled: Bool { scheduledEvent == nil }
        
        public init(
            eventId: UInt32,
            scheduledEvent: ScheduledEvent?
        ) {
            self.eventId = eventId
            self.scheduledEvent = scheduledEvent
        }
    }
}

public extension SpliceSchedule.Event {
    struct ScheduledEvent: Equatable {
        /// When set to `true`, indicates that the splice event is an opportunity to exit from the
        /// network feed and that the value of `utcSpliceTime` shall refer to an intended out point
        /// or program out point. When set to `false`, the flag indicates that the splice event is
        /// an opportunity to return to the network feed and that the value of `utcSpliceTime` shall
        /// refer to an intended in point or program in point.
        public let outOfNetworkIndicator: Bool
        /// Information on the type of splice message.
        public let spliceMode: SpliceMode
        /// The `BreakDuration` structure specifies the duration of the commercial break(s). It may
        /// be used to give the splicer an indication of when the break will be over and when the
        /// network in point will occur.
        public let breakDuration: BreakDuration?
        /// This value should provide a unique identification for a viewing event within the service.
        public let uniqueProgramId: UInt16
        /// This field provides an identification for a specific avail within one `uniqueProgramId`.
        /// This value is expected to increment with each new avail within a viewing event. This
        /// value is expected to reset to one for the first avail in a new viewing event. This field
        /// is expected to increment for each new avail. It may optionally carry a zero value to
        /// indicate its non-usage.
        public let availNum: UInt8
        /// This field provides a count of the expected number of individual avails within the
        /// current viewing event. When this field is zero, it indicates that the `availNum` field
        /// has no meaning.
        public let availsExpected: UInt8
        
        public init(
            outOfNetworkIndicator: Bool,
            spliceMode: SpliceMode,
            breakDuration: BreakDuration?,
            uniqueProgramId: UInt16,
            availNum: UInt8,
            availsExpected: UInt8
        ) {
            self.outOfNetworkIndicator = outOfNetworkIndicator
            self.spliceMode = spliceMode
            self.breakDuration = breakDuration
            self.uniqueProgramId = uniqueProgramId
            self.availNum = availNum
            self.availsExpected = availsExpected
        }
    }
}

public extension SpliceSchedule.Event.ScheduledEvent {
    /// Information on the type of splice message.
    enum SpliceMode: Equatable {
        /// Indicates that the message refers to a Program Splice Point and that the mode is the
        /// Program Splice Mode whereby all PIDs/components of the program are to be spliced.
        case programSpliceMode(ProgramMode)
        /// Indicates that the mode is the Component Splice Mode whereby each component that is
        /// intended to be spliced will be listed separately by the syntax that follows.
        case componentSpliceMode([ComponentMode])
    }
}

public extension SpliceSchedule.Event.ScheduledEvent.SpliceMode {
    /// Indicates that the message refers to a Program Splice Point and that the mode is the
    /// Program Splice Mode whereby all PIDs/components of the program are to be spliced.
    struct ProgramMode: Equatable {
        /// A 32-bit unsigned integer quantity representing the time of the signalled splice event
        /// as the number of seconds since 00 hours coordinated universal time (UTC), January 6th,
        /// 1980, with the count of intervening leap seconds included. The `utcSpliceTime` may be
        /// converted to UTC without the use of the GPS_UTC_offset value provided by the System Time
        /// table. The `utcSpliceTime` field is used only in the `SpliceSchedule` command.
        public let utcSpliceTime: UInt32
        
        public init(utcSpliceTime: UInt32) {
            self.utcSpliceTime = utcSpliceTime
        }
    }
    
    /// Indicates that the mode is the Component Splice Mode whereby each component that is
    /// intended to be spliced will be listed separately by the syntax that follows.
    struct ComponentMode: Equatable {
        /// An 8-bit value that identifies the elementary PID stream containing the Splice Point
        /// specified by the value of `utcSpliceTime` that follows. The value shall be the same as
        /// the value used in the stream_identification_descriptor() to identify that elementary
        /// PID stream.
        public let componentTag: UInt8
        /// A 32-bit unsigned integer quantity representing the time of the signalled splice event
        /// as the number of seconds since 00 hours coordinated universal time (UTC), January 6th,
        /// 1980, with the count of intervening leap seconds included. The `utcSpliceTime` may be
        /// converted to UTC without the use of the GPS_UTC_offset value provided by the System Time
        /// table. The `utcSpliceTime` field is used only in the `SpliceSchedule` command.
        public let utcSpliceTime: UInt32
        
        public init(
            componentTag: UInt8,
            utcSpliceTime: UInt32
        ) {
            self.componentTag = componentTag
            self.utcSpliceTime = utcSpliceTime
        }
    }
}

// MARK: - Parsing

extension SpliceSchedule {
    init(bitReader: DataBitReader) throws {
        let spliceCount = bitReader.byte()
        self.events = try (0..<spliceCount).map { _ in try SpliceSchedule.Event(bitReader: bitReader) }
    }
}

extension SpliceSchedule.Event {
    init(bitReader: DataBitReader) throws {
        self.eventId = bitReader.uint32(fromBits: 32)
        let isCancelled = bitReader.bit() == 1
        _ = bitReader.bits(count: 7)
        if isCancelled {
            self.scheduledEvent = nil
        } else {
            self.scheduledEvent = try SpliceSchedule.Event.ScheduledEvent(bitReader: bitReader)
        }
    }
}

extension SpliceSchedule.Event.ScheduledEvent {
    init(bitReader: DataBitReader) throws {
        self.outOfNetworkIndicator = bitReader.bit() == 1
        let programSpliceFlag = bitReader.bit() == 1
        let durationFlag = bitReader.bit() == 1
        _ = bitReader.bits(count: 5)
        if programSpliceFlag {
            self.spliceMode = .programSpliceMode(
                SpliceMode.ProgramMode(utcSpliceTime: bitReader.uint32(fromBits: 32))
            )
        } else {
            let componentCount = bitReader.byte()
            self.spliceMode = .componentSpliceMode(
                (0..<componentCount).map { _ in
                    let componentTag = bitReader.byte()
                    let utcSpliceTime = bitReader.uint32(fromBits: 32)
                    return SpliceMode.ComponentMode(
                        componentTag: componentTag,
                        utcSpliceTime: utcSpliceTime
                    )
                }
            )
        }
        if durationFlag {
            self.breakDuration = try BreakDuration(bitReader: bitReader)
        } else {
            self.breakDuration = nil
        }
        self.uniqueProgramId = bitReader.uint16(fromBits: 16)
        self.availNum = bitReader.byte()
        self.availsExpected = bitReader.byte()
    }
}
