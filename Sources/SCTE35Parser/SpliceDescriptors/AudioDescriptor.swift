//
//  AudioDescriptor.swift
//  
//
//  Created by Robert Galluccio on 06/02/2021.
//

/// The `AudioDescriptor` should be used when programmers and/or MVPDs do not support dynamic signaling
/// (e.g., signaling of audio language changes) and with legacy audio formats that do not support dynamic
/// signaling. As discussed in Section 9.1.5 of the SCTE Operational Practice on Multiple Audio Signaling
/// [SCTE 248], since most MVPD head-ends do not change the PAT/PMT to signal changed audio streams, this
/// descriptor in SCTE 35 should be used to signal such changes. This descriptor is an implementation of
/// a `SpliceDescriptor`. It provides the ability to dynamically signal the audios actually in use in the
/// stream. This descriptor shall only be used with a `TimeSignal` command and a segmentation descriptor
/// with the type `programStart` or `programOverlapStart`.
/**
 ```
 {
   splice_descriptor_tag            8 uimsbf
   descriptor_length                8 uimsbf
   identifier                      32 uimsbf
   audio_count                      4 uimsbf
   reserved                         4 bslbf
   for (i=0; i<audio_count; i++) {
     component_tag                  8 uimsbf
     ISO_code                      24 uimsbf
     Bit_Stream_Mode                3 uimsbf
     Num_Channels                   4 uimsbf
     Full_Srvc_Audio                1 uimsbf
   }
 }
 ```
 */
public struct AudioDescriptor: Equatable {
    /// This 32-bit number is used to identify the owner of the descriptor. The identifier shall have a
    /// value of 0x43554549 (ASCII “CUEI”).
    public let identifier: UInt32
    /// The audio PIDs in the program.
    public let components: [Component]
    
    public init(
        identifier: UInt32,
        components: [Component]
    ) {
        self.identifier = identifier
        self.components = components
    }
}

public extension AudioDescriptor {
    struct Component: Equatable {
        /// An optional 8-bit value that identifies the elementary PID stream containing the audio
        /// channel that follows. If used, the value shall be the same as the value used in the
        /// `stream_identifier_descriptor()` to identify that elementary PID stream. If this is not used,
        /// the value shall be 0xFF and the stream order shall be inferred from the PMT audio order.
        public let componentTag: UInt8
        /// This field is a 3-byte language code defining the language of this audio service which shall
        /// correspond to a registered language code contained in the Code column of the [ISO 639-2]
        /// registry.
        public let isoCode: UInt32
        /// This is a 3-bit field that is set to the same value as the bsmod field in the AC-3 elementary
        /// stream.
        public let bitStreamMode: BitStreamMode
        /// This is a 4-bit field that indicates the number of channels in the AC-3 elementary stream.
        /// When the MSB is 0, the lower 3 bits are set to the same value as the acmod field in the AC-3
        /// elementary stream. When the MSB field is 1, the lower 3 bits indicate the maximum number of
        /// encoded audio channels (counting the lfe channel as 1).
        public let numChannels: NumChannels
        /// This is a 1-bit field that indicates if this audio service is a full service suitable for
        /// presentation, or a partial service which should be combined with another audio service before
        /// presentation. This bit should be set to `true` if this audio service is sufficiently complete
        /// to be presented to the listener without being combined with another audio service (for
        /// example, a visually impaired service which contains all elements of the Program; music,
        /// effects, dialogue, and the visual content descriptive narrative). This bit should be set to
        /// `false` if the service is not sufficiently complete to be presented without being combined
        /// with another audio service (e.g., a visually impaired service which only contains a narrative
        /// description of the visual Program content and which needs to be combined with another audio
        /// service which contains music, effects, and dialogue).”
        public let fullSrvcAudio: Bool
        
        public init(
            componentTag: UInt8,
            isoCode: UInt32,
            bitStreamMode: BitStreamMode,
            numChannels: NumChannels,
            fullSrvcAudio: Bool
        ) {
            self.componentTag = componentTag
            self.isoCode = isoCode
            self.bitStreamMode = bitStreamMode
            self.numChannels = numChannels
            self.fullSrvcAudio = fullSrvcAudio
        }
    }
}

public extension AudioDescriptor {
    /// This is a 4-bit field that indicates the number of channels in the AC-3 elementary stream.
    /// When the MSB is 0, the lower 3 bits are set to the same value as the acmod field in the AC-3
    /// elementary stream. When the MSB field is 1, the lower 3 bits indicate the maximum number of
    /// encoded audio channels (counting the lfe channel as 1).
    enum NumChannels: Equatable {
        case audioCodingMode(AudioCodingMode)
        case maxNumberOfEncodedChannels(MaxNumberOfEncodedChannels)
    }
    
    /// indicates the maximum number of encoded audio channels (counting the lfe channel as 1).
    enum MaxNumberOfEncodedChannels: Equatable {
        case one
        case two
        case three
        case four
        case five
        case six
        case unknown(UInt8)
        
        public init(_ rawValue: UInt8) {
            switch rawValue {
            case 0: self = .one
            case 1: self = .two
            case 2: self = .three
            case 3: self = .four
            case 4: self = .five
            case 5: self = .six
            default: self = .unknown(rawValue)
            }
        }
    }
}

// MARK: - Parsing

extension AudioDescriptor {
    // NOTE: It is assumed that the splice_descriptor_tag has already been read.
    init(bitReader: DataBitReader) throws {
        let descriptorLength = bitReader.byte()
        let bitsReadBeforeDescriptor = bitReader.bitsRead
        let expectedBitsReadAtEndOfDescriptor = bitReader.bitsRead + (Int(descriptorLength) * 8)
        self.identifier = bitReader.uint32(fromBits: 32)
        let audioCount = bitReader.byte(fromBits: 4)
        _ = bitReader.bits(count: 4)
        self.components = try (0..<audioCount).map { _ in try Component(bitReader: bitReader) }
        if bitReader.bitsRead != expectedBitsReadAtEndOfDescriptor {
            bitReader.nonFatalErrors.append(
                .unexpectedSpliceDescriptorLength(
                    UnexpectedSpliceDescriptorLengthErrorInfo(
                        declaredSpliceDescriptorLengthInBits: (Int(descriptorLength) * 8),
                        actualSpliceDescriptorLengthInBits: bitReader.bitsRead - bitsReadBeforeDescriptor,
                        spliceDescriptorTag: .audioDescriptor
                    )
                )
            )
        }
    }
}

extension AudioDescriptor.Component {
    init(bitReader: DataBitReader) throws {
        self.componentTag = bitReader.byte()
        self.isoCode = bitReader.uint32(fromBits: 24)
        let bsmod = bitReader.byte(fromBits: 3)
        if bitReader.bit() == 0 {
            let acmod = bitReader.byte(fromBits: 3)
            guard let audioCodingMode = AudioCodingMode(rawValue: acmod) else {
                throw ParserError.unrecognisedAudioCodingMode(Int(acmod))
            }
            guard let bitStreamMode = BitStreamMode(bsmod: bsmod, acmod: acmod) else {
                throw ParserError.invalidBitStreamMode(InvalidBitStreamModeErrorInfo(bsmod: Int(bsmod), acmod: Int(acmod)))
            }
            self.bitStreamMode = bitStreamMode
            self.numChannels = .audioCodingMode(audioCodingMode)
        } else {
            let nChannels = AudioDescriptor.MaxNumberOfEncodedChannels(bitReader.byte(fromBits: 3))
            guard let bitStreamMode = BitStreamMode(bsmod: bsmod, acmod: nil) else {
                throw ParserError.invalidBitStreamMode(InvalidBitStreamModeErrorInfo(bsmod: Int(bsmod), acmod: nil))
            }
            self.bitStreamMode = bitStreamMode
            self.numChannels = .maxNumberOfEncodedChannels(nChannels)
        }
        self.fullSrvcAudio = bitReader.bit() == 1
    }
}
