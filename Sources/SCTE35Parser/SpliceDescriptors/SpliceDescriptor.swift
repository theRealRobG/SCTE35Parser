//
//  SpliceDescriptor.swift
//  
//
//  Created by Robert Galluccio on 30/01/2021.
//

/// The `SpliceDescriptor` is a prototype for adding new fields to the `SpliceInfoSection`. All
/// descriptors included use the same syntax for the first six bytes. In order to allow private
/// information to be added we have included the `identifier` code. This removes the need for a
/// registration descriptor in the descriptor loop.
/// Splice descriptors may exist in the `SpliceInfoSection` for extensions specific to the various
/// commands.
///
/// **Implementers note:** Multiple descriptors of the same or different types in a single command are
/// allowed and may be common. The only limit on the number of descriptors is the `sectionLength` in
/// `SpliceInfoSection`, although there may be other practical or implementation limits.
/**
 ```
 splice_descriptor() {
   splice_descriptor_tag  8 uimsbf
   descriptor_length      8 uimsbf
   identifier            32 uimsbf
   for(i=0; i<N; i++) {
     private_byte         8 uimsbf
   }
 }
 ```
 */
public enum SpliceDescriptor {
    /// The `availDescriptor` provides an optional extension to the `SpliceInsert` command that allows an
    /// authorization identifier to be sent for an avail. Multiple copies of this descriptor may be
    /// included by using the loop mechanism provided. This identifier is intended to replicate the
    /// functionality of the cue tone system used in analogue systems for ad insertion. This descriptor
    /// is intended only for use with a `SpliceInsert` command, within a `SpliceInfoSection`.
    case availDescriptor(AvailDescriptor)
    /// The `dtmfDescriptor` provides an optional extension to the `SpliceInsert` command that allows a
    /// receiver device to generate a legacy analogue DTMF sequence based on a `SpliceInfoSection` being
    /// received.
    case dtmfDescriptor(DTMFDescriptor)
    /// The `segmentationDescriptor` provides an optional extension to the `TimeSignal` and
    /// `SpliceInsert` commands that allows for segmentation messages to be sent in a time/video accurate
    /// method. This descriptor shall only be used with the `TimeSignal`, `SpliceInsert` and the
    /// `SpliceNull` commands. The `TimeSignal` or `SpliceInsert` message should be sent at least once a
    /// minimum of 4 seconds in advance of the signaled `SpliceTime` to permit the insertion device to
    /// place the `SpliceInfoSection` accurately. Devices that do not recognize a value in any field
    /// shall ignore the message and take no action.
    case segmentationDescriptor(SegmentationDescriptor)
    case timeDescriptor
    case audioDescriptor
    
    /// This 8 bit number defines the syntax for the private bytes that make up the body of this
    /// descriptor. The descriptor tags are defined by the owner of the descriptor, as registered using
    /// the identifier.
    public var tag: SpliceDescriptorTag {
        switch self {
        case .availDescriptor: return .availDescriptor
        case .dtmfDescriptor: return .dtmfDescriptor
        case .segmentationDescriptor: return .segmentationDescriptor
        case .timeDescriptor: return .timeDescriptor
        case .audioDescriptor: return .audioDescriptor
        }
    }
    
    /// This 32 bit number is used to identify the owner of the descriptor.
    ///
    /// The identifier is a 32-bit field as defined in [ITU-T H.222.0]. Refer to clauses 2.6.8 and 2.6.9
    /// of [ITU-T H.222.0] for a description of registration descriptor and the semantic definition of
    /// fields in the registration descriptor. Only identifier values registered and recognized by SMPTE
    /// registration authority, LLC should be used. Its use in this descriptor shall scope and identify
    /// only the private information contained within this descriptor. The code 0x43554549 (ASCII "CUEI")
    /// for descriptors defined in this specification has been registered with SMPTE.
    public var identifier: UInt32 {
        fatalError("TODO - implement once all descriptors are implemented")
    }
}
