//
//  SegmentationDescriptor+SegmentationUPID.swift
//
//
//  Created by Robert Galluccio on 04/02/2021.
//

import Foundation

public extension SegmentationDescriptor {
    /// There are multiple types allowed to ensure that programmers will be able to use an id that their
    /// systems support. It is expected that the consumers of these ids will have an out-of-band method
    /// of collecting other data related to these numbers and therefore they do not need to be of
    /// identical types. These ids may be in other descriptors in the Program and, where the same
    /// identifier is used (ISAN for example), it shall match between Programs.
    enum SegmentationUPID {
        /// The `SegmentationUPID` is not defined and is not present in the descriptor.
        case notUsed
        /// Deprecated: use type `0x0C`; The `SegmentationUPID` does not follow a standard naming scheme.
        case userDefined(String)
        /// Deprecated: use type `0x03`, 8 characters; 4 alpha characters followed by 4 numbers.
        case isci(String)
        /// Defined by the Advertising Digital Identification, LLC group. 12 characters; 4 alpha
        /// characters (company identification prefix) followed by 8 alphanumeric characters. (See `adID`)
        case adID(String)
        /// See [SMPTE 330]
        case umid(String)
        /// Deprecated: use type `0x06`, ISO 15706 binary encoding.
        case deprecatedISAN(String)
        /// Formerly known as V-ISAN. ISO 15706-2 binary encoding (“versioned” ISAN). See [ISO 15706-2].
        case isan(String)
        /// Tribune Media Systems Program identifier. 12 characters; 2 alpha characters followed by 10
        /// numbers.
        case tid(String)
        /// AiringID (Formerly Turner ID), used to indicate a specific airing of a Program that is unique
        /// within a network.
        case ti(String)
        /// CableLabs metadata identifier.
        ///
        /// When the value of `SegmentationUPIDType` is `0x09` (ADI), it shall have the abbreviated
        /// syntax of `<element> : <identifier>`. The variable `<element>` shall take only the values
        /// `“PREVIEW”`, `“MPEG2HD”`, `“MPEG2SD”`, `“AVCHD”`, `“AVCSD”`, `“HEVCSD”`, `“HEVCHD”`,
        /// `“SIGNAL”`, `“PO”` (PlacementOpportunity), `“BLACKOUT”` and `“OTHER”`.
        ///
        /// For CableLabs Content metadata 1.1 the variable `<identifier>` shall take the form
        /// `<providerID>/<assetID>`, the variables `<providerID>` and `<assetID>` shall be as specified
        /// in [CLADI1-1] Sections 5.3.1 for Movie or 5.5.1 for Preview represented as 7-bit printable
        /// ASCII characters (values ranging from 0x20 (space) to 0x7E (tilde)).
        ///
        /// SCTE 2362 provides compatibility with this identifier model as described in [SCTE 236]
        /// Section 7.11.1.
        case adi(String)
        /// An EIDR (see [EIDR]) represented in Compact Binary encoding as defined in Section 2.1.1 in
        /// EIDR ID Format (see [EIDR ID FORMAT])
        case eidr(String)
        /// `ATSC_content_identifier()` structure as defined in [ATSC A/57B].
        case atscContentIdentifier(String)
        /// Managed Private UPID structure.
        case mpu(ManagedPrivateUPID)
        /// Multiple UPID types structure.
        case mid([SegmentationUPID])
        /// Advertising information. The specific usage is out of scope of this standard.
        case adsInformation(String)
        /// Universal Resource Identifier (see [RFC 3986]).
        case uri(String)
        /// Universally Unique Identifier (see [RFC 4122]). This `SegmentationUPIDType` can be used
        /// instead of an URI if it is desired to transfer the UUID payload only.
        case uuid(UUID)
        
        public var type: SegmentationUPIDType {
            switch self {
            case .notUsed: return .notUsed
            case .userDefined: return .userDefined
            case .isci: return .isci
            case .adID: return .adID
            case .umid: return .umid
            case .deprecatedISAN: return .deprecatedISAN
            case .isan: return .isan
            case .tid: return .tid
            case .ti: return .ti
            case .adi: return .adi
            case .eidr: return .eidr
            case .atscContentIdentifier: return .atscContentIdentifier
            case .mpu: return .mpu
            case .mid: return .mid
            case .adsInformation: return .adsInformation
            case .uri: return .uri
            case .uuid: return .uuid
            }
        }
    }
}

public extension SegmentationDescriptor {
    struct ManagedPrivateUPID {
        public let formatSpecifier: String
        public let privateData: Any
    }
}
