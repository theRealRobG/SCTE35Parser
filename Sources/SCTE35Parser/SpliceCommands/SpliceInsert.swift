//
//  SpliceInsert.swift
//  
//
//  Created by Robert Galluccio on 30/01/2021.
//

/// The `SpliceInsert` command shall be sent at least once for every splice event.
/**
 ```
 splice_insert() {
   splice_event_id                                                      32 uimsbf
   splice_event_cancel_indicator                                         1 bslbf
   reserved                                                              7 bslbf
   if(splice_event_cancel_indicator == '0') {
     out_of_network_indicator                                            1 bslbf
     program_splice_flag                                                 1 bslbf
     duration_flag                                                       1 bslbf
     splice_immediate_flag                                               1 bslbf
     reserved                                                            4 bslbf
     if((program_splice_flag == '1') && (splice_immediate_flag == '0'))
       splice_time()
     if(program_splice_flag == '0') {
       component_count                                                   8 uimsbf
       for(i=0;i<component_count;i++) {
         component_tag                                                   8 uimsbf
         if(splice_immediate_flag == '0')
           splice_time()
       }
     }
     if(duration_flag == '1')
       break_duration()
     unique_program_id                                                  16 uimsbf
     avail_num                                                           8 uimsbf
     avails_expected                                                     8 uimsbf
   }
 }
 ```
 */
public struct SpliceInsert: Equatable {
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

public extension SpliceInsert {
    struct ScheduledEvent: Equatable {
        /// When set to `true`, indicates that the splice event is an opportunity to exit from the
        /// network feed and that the value of `spliceTime`, as modified by `ptsAdjustment`, shall
        /// refer to an intended out point or program out point. When set to `false`, the flag
        /// indicates that the splice event is an opportunity to return to the network feed and that
        /// the value of `spliceTime`, as modified by `ptsAdjustment`, shall refer to an intended in
        /// point or program in point.
        public let outOfNetworkIndicator: Bool
        /// When this flag is `true`, it indicates the absence of the `spliceTime` field and that the
        /// splice mode shall be the Splice Immediate Mode, whereby the splicing device shall choose
        /// the nearest opportunity in the stream, relative to the splice information packet, to splice.
        /// When this flag is `false`, it indicates the presence of the `spliceTime` field in at least
        /// one location within the `SpliceInsert` command.
        ///
        /// In this specific scenario, a value of `true` indicates that all `spliceTime` values within
        /// the `spliceMode` enum will be `nil`, and the converse for a value of `false`.
        public let isImmediateSplice: Bool
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
            isImmediateSplice: Bool,
            spliceMode: SpliceMode,
            breakDuration: BreakDuration?,
            uniqueProgramId: UInt16,
            availNum: UInt8,
            availsExpected: UInt8
        ) {
            self.outOfNetworkIndicator = outOfNetworkIndicator
            self.isImmediateSplice = isImmediateSplice
            self.spliceMode = spliceMode
            self.breakDuration = breakDuration
            self.uniqueProgramId = uniqueProgramId
            self.availNum = availNum
            self.availsExpected = availsExpected
        }
    }
}

public extension SpliceInsert.ScheduledEvent {
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

public extension SpliceInsert.ScheduledEvent.SpliceMode {
    /// Indicates that the message refers to a Program Splice Point and that the mode is the
    /// Program Splice Mode whereby all PIDs/components of the program are to be spliced.
    struct ProgramMode: Equatable {
        /// The `SpliceTime` structure, when modified by `ptsAdjustment`, specifies the time of the
        /// splice event.
        public let spliceTime: SpliceTime?
        
        public init(spliceTime: SpliceTime?) {
            self.spliceTime = spliceTime
        }
    }
    
    /// Indicates that the mode is the Component Splice Mode whereby each component that is
    /// intended to be spliced will be listed separately by the syntax that follows.
    struct ComponentMode: Equatable {
        /// An 8-bit value that identifies the elementary PID stream containing the Splice Point
        /// specified by the value of `spliceTime` that follows. The value shall be the same as
        /// the value used in the stream_identification_descriptor() to identify that elementary
        /// PID stream.
        public let componentTag: UInt8
        /// The `SpliceTime` structure, when modified by `ptsAdjustment`, specifies the time of the
        /// splice event.
        public let spliceTime: SpliceTime?
        
        public init(
            componentTag: UInt8,
            spliceTime: SpliceTime?
        ) {
            self.componentTag = componentTag
            self.spliceTime = spliceTime
        }
    }
}

// MARK: - Parsing

extension SpliceInsert {
    init(bitReader: DataBitReader) throws {
        self.eventId = bitReader.uint32(fromBits: 32)
        let isSpliceEventCancelled = bitReader.bit() == 1
        _ = bitReader.bits(count: 7)
        if isSpliceEventCancelled {
            self.scheduledEvent = nil
        } else {
            self.scheduledEvent = try ScheduledEvent(bitReader: bitReader)
        }
    }
}

private extension SpliceInsert.ScheduledEvent {
    init(bitReader: DataBitReader) throws {
        self.outOfNetworkIndicator = bitReader.bit() == 1
        let programSpliceFlag = bitReader.bit() == 1
        let durationFlag = bitReader.bit() == 1
        let spliceImmediateFlag = bitReader.bit() == 1
        self.isImmediateSplice = spliceImmediateFlag
        _ = bitReader.bits(count: 4)
        if programSpliceFlag {
            self.spliceMode = .programSpliceMode(
                SpliceMode.ProgramMode(
                    spliceTime: spliceImmediateFlag ? nil : try SpliceTime(bitReader: bitReader)
                )
            )
        } else {
            let componentCount = bitReader.byte()
            self.spliceMode = try .componentSpliceMode(
                (0..<componentCount).reduce(into: [SpliceMode.ComponentMode]()) { segments, _ in
                    let componentTag = bitReader.byte()
                    segments.append(
                        SpliceMode.ComponentMode(
                            componentTag: componentTag,
                            spliceTime: spliceImmediateFlag ? nil : try SpliceTime(bitReader: bitReader)
                        )
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
