//
//  SegmentationDescriptor.swift
//  
//
//  Created by Robert Galluccio on 30/01/2021.
//

/// The `SegmentationDescriptor` is an implementation of a `SpliceDescriptor`. It provides an optional
/// extension to the `TimeSignal` and `SpliceInsert` commands that allows for segmentation messages to
/// be sent in a time/video accurate method. This descriptor shall only be used with the `TimeSignal`,
/// `SpliceInsert` and the `SpliceNull` commands. The `TimeSignal` or `SpliceInsert` message should be
/// sent at least once a minimum of 4 seconds in advance of the signaled `SpliceTime` to permit the
/// insertion device to place the `SpliceInfoSection` accurately. Devices that do not recognize a value
/// in any field shall ignore the message and take no action.
/**
 ```
 segmentation_descriptor() {
   splice_descriptor_tag                             8 uimsbf
   descriptor_length                                 8 uimsbf
   identifier                                       32 uimsbf
   segmentation_event_id                            32 uimsbf
   segmentation_event_cancel_indicator               1 bslbf
   reserved                                          7 bslbf
   if(segmentation_event_cancel_indicator == ‘0’) {
     program_segmentation_flag                       1 bslbf
     segmentation_duration_flag                      1 bslbf
     delivery_not_restricted_flag                    1 bslbf
     if(delivery_not_restricted_flag == ‘0’) {
       web_delivery_allowed_flag                     1 bslbf
       no_regional_blackout_flag                     1 bslbf
       archive_allowed_flag                          1 bslbf
       device_restrictions                           2 bslbf
     } else {
       reserved                                      5 bslbf
     }
     if(program_segmentation_flag == ‘0’) {
       component_count                               8 uimsbf
       for(i=0;i<component_count;i++) {
         component_tag                               8 uimsbf
         reserved                                    7 bslbf
         pts_offset                                 33 uimsbf
       }
     }
     if(segmentation_duration_flag == ‘1’)
       segmentation_duration                        40 uimsbf
     segmentation_upid_type                          8 uimsbf
     segmentation_upid_length                        8 uimsbf
     segmentation_upid()
     segmentation_type_id                            8 uimsbf
     segment_num                                     8 uimsbf
     segments_expected                               8 uimsbf
     if(segmentation_type_id == ‘0x34’ ||
       segmentation_type_id == ‘0x36’ ||
       segmentation_type_id == ‘0x38’ ||
       segmentation_type_id == ‘0x3A’) {
         sub_segment_num                             8 uimsbf
         sub_segments_expected                       8 uimsbf
     }
   }
 }
 ```
 */
public struct SegmentationDescriptor {
    /// This 32-bit number is used to identify the owner of the descriptor. The identifier shall have a
    /// value of 0x43554549 (ASCII “CUEI”).
    public let identifier: UInt32
    /// A 32-bit unique segmentation event identifier.
    public let eventId: UInt32
    /// Information on the scheduled event. If this value is `nil` it indicates that a previously
    /// sent segmentation descriptor, identified by `eventId`, has been cancelled.
    public let scheduledEvent: ScheduledEvent?
    /// When set to `true` indicates that a previously sent segmentation descriptor, identified by
    /// `eventId`, has been cancelled.
    public var isCancelled: Bool { scheduledEvent == nil }
}

public extension SegmentationDescriptor {
    struct ScheduledEvent {
        /// This is provided to facilitate implementations that use methods that are out of scope of this
        /// standard to process and manage this Segment.
        public let deliveryRestrictions: DeliveryRestrictions?
        /// When not defined, indicates that the message refers to a Program Segmentation Point and that
        /// the mode is the Program Segmentation Mode whereby all PIDs/components of the program are to be
        /// segmented. When defined, this field indicates that the mode is the Component Segmentation
        /// Mode whereby each component that is intended to be segmented will be listed separately.
        public let componentSegments: [ComponentSegmentation]?
        /// A 40-bit unsigned integer that specifies the duration of the Segment in terms of ticks of the
        /// program’s 90 kHz clock. It may be used to give the splicer an indication of when the Segment
        /// will be over and when the next segmentation message will occur. Shall be `0` for end messages.
        public let segmentationDuration: UInt64?
        /// There are multiple types allowed to ensure that programmers will be able to use an id that
        /// their systems support. It is expected that the consumers of these ids will have an
        /// out-of-band method of collecting other data related to these numbers and therefore they do
        /// not need to be of identical types. These ids may be in other descriptors in the Program and,
        /// where the same identifier is used (ISAN for example), it shall match between Programs.
        public let segmentationUPID: SegmentationUPID
        /// Designates the type of segmentation. All unused values are reserved. When the
        /// `SegmentationTypeID` is `0x01` (`contentIdentification`), the value of `SegmentationUPIDType`
        /// shall be non-zero. If `segmentationUPIDLength` is zero, then `SegmentationTypeID` shall be
        /// set to `0x00` for Not Indicated.
        public let segmentationTypeID: SegmentationTypeID
        /// This field provides support for numbering segments within a given collection of Segments
        /// (such as Chapters or Advertisements). This value, when utilized, is expected to reset to one
        /// at the beginning of a collection of Segments. This field is expected to increment for each
        /// new Segment (such as a Chapter).
        public let segmentNum: UInt8
        /// This field provides a count of the expected number of individual Segments (such as Chapters)
        /// within a collection of Segments.
        public let segmentsExpected: UInt8
        /// Provides information for a collection of sub-Segments.
        public let subSegment: SubSegment?
    }
}

public extension SegmentationDescriptor.ScheduledEvent {
    /// This is provided to facilitate implementations that use methods that are out of scope of this
    /// standard to process and manage this Segment.
    struct DeliveryRestrictions {
        /// This shall have the value of `true` when there are no restrictions with respect to web
        /// delivery of this Segment. This shall have the value of `false` to signal that restrictions
        /// related to web delivery of this Segment are asserted.
        public let webDeliveryAllowed: Bool
        /// This shall have the value of `true` when there is no regional blackout of this Segment. This
        /// shall have the value of `false` when this Segment is restricted due to regional blackout
        /// rules.
        public let noRegionalBlackout: Bool
        /// This shall have the value of `true` when there is no assertion about recording this Segment.
        /// This shall have the value of `false` to signal that restrictions related to recording this
        /// Segment are asserted.
        public let archiveAllowed: Bool
        /// This field signals three pre-defined groups of devices. The population of each group is
        /// independent and the groups are non-hierarchical. The delivery and format of the messaging to
        /// define the devices contained in the groups is out of the scope of this standard.
        public let deviceRestrictions: DeviceRestrictions
    }
}

public extension SegmentationDescriptor.ScheduledEvent.DeliveryRestrictions {
    /// This field signals three pre-defined groups of devices. The population of each group is
    /// independent and the groups are non-hierarchical. The delivery and format of the messaging to
    /// define the devices contained in the groups is out of the scope of this standard.
    enum DeviceRestrictions {
        /// This Segment is restricted for a class of devices defined by an out of band message that
        /// describes which devices are excluded.
        case restrictGroup0 // 00
        /// This Segment is restricted for a class of devices defined by an out of band message that
        /// describes which devices are excluded.
        case restrictGroup1 // 01
        /// This Segment is restricted for a class of devices defined by an out of band message that
        /// describes which devices are excluded.
        case restrictGroup2 // 10
        /// This Segment has no device restrictions.
        case none           // 11
    }
}

public extension SegmentationDescriptor.ScheduledEvent {
    struct ComponentSegmentation {
        /// An 8-bit value that identifies the elementary PID stream containing the Segmentation Point
        /// specified by the value of `SpliceTime` that follows. The value shall be the same as the value
        /// used in the `stream_identifier_descriptor()` to identify that elementary PID stream. The
        /// presence of this field from the component loop denotes the presence of this component of the
        /// asset.
        public let componentTag: UInt8
        /// A 33-bit unsigned integer that shall be used by a splicing device as an offset to be added to
        /// the `ptsTime`, as modified by `ptsAdjustment`, in the `TimeSignal` message to obtain the
        /// intended splice time(s). When this field has a zero value, then the `ptsTime` field(s) shall
        /// be used without an offset. If `SpliceTime` has no `ptsTime` or if the command this descriptor
        /// is carried with does not have a `SpliceTime` field, this field shall be used to offset the
        /// derived immediate splice time.
        public let ptsOffset: UInt64
    }
}

public extension SegmentationDescriptor.ScheduledEvent {
    struct SubSegment {
        /// If specified, this field provides identification for a specific sub-Segment within a
        /// collection of sub-Segments. This value, when utilized, is expected to be set to one for the
        /// first sub-Segment within a collection of sub-Segments. This field is expected to increment by
        /// one for each new sub-Segment within a given collection.
        public let subSegmentNum: UInt8
        /// If specified, this field provides a count of the expected number of individual sub-Segments
        /// within the collection of sub-Segments.
        public let subSegmentsExpected: UInt8
    }
}
