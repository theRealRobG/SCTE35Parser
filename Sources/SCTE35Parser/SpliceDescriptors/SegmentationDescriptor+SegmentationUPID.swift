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
    enum SegmentationUPID: Equatable {
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
        case atscContentIdentifier(ATSCContentIdentifier)
        /// Managed Private UPID structure.
        case mpu(ManagedPrivateUPID)
        /// Multiple UPID types structure.
        case mid([SegmentationUPID])
        /// Advertising information. The specific usage is out of scope of this standard.
        case adsInformation(String)
        /// Universal Resource Identifier (see [RFC 3986]).
        case uri(URL)
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
    struct ManagedPrivateUPID: Equatable {
        public let formatSpecifier: String
        public let privateData: Data
        
        public init(
            formatSpecifier: String,
            privateData: Data
        ) {
            self.formatSpecifier = formatSpecifier
            self.privateData = privateData
        }
    }
}

// MARK: - Parsing

extension SegmentationDescriptor.SegmentationUPID {
    // NOTE: It is assumed that this is starting reading from segmentation_upid_type
    init(bitReader: DataBitReader) throws {
        let upidTypeRawValue = bitReader.byte()
        guard let upidType = SegmentationDescriptor.SegmentationUPIDType(rawValue: upidTypeRawValue) else {
            throw ParserError.unrecognisedSegmentationUPIDType(Int(upidTypeRawValue))
        }
        let upidLength = bitReader.byte()
        try bitReader.validate(
            expectedMinimumBitsLeft: Int(upidLength) * 8,
            parseDescription: "SegmentationUPID; reading loop"
        )
        try self.init(bitReader: bitReader, upidType: upidType, upidLength: upidLength)
    }
    
    init(
        bitReader: DataBitReader,
        upidType: SegmentationDescriptor.SegmentationUPIDType,
        upidLength: UInt8
    ) throws {
        switch upidType {
        case .notUsed:
            try validate(upidLength: upidLength, expectedLength: 0, upidType: upidType)
            self = .notUsed
        case .userDefined:
            self = .userDefined(bitReader.string(fromBytes: UInt(upidLength)))
        case .isci:
            try validate(upidLength: upidLength, expectedLength: 8, upidType: upidType)
            self = .isci(bitReader.string(fromBytes: 8))
        case .adID:
            try validate(upidLength: upidLength, expectedLength: 12, upidType: upidType)
            self = .adID(bitReader.string(fromBytes: 12))
        case .umid:
            try validate(upidLength: upidLength, expectedLength: 32, upidType: upidType)
            let umid = (0...7)
                .map { _ in String(format: "%08X", bitReader.uint32(fromBits: 32)) }
                .joined(separator: ".")
            self = .umid(umid)
        case .deprecatedISAN:
            try validate(upidLength: upidLength, expectedLength: 8, upidType: upidType)
            self = .deprecatedISAN(HyphenSeparatedCheckedHex(.deprecatedISAN).read(using: bitReader))
        case .isan:
            try validate(upidLength: upidLength, expectedLength: 12, upidType: upidType)
            self = .isan(HyphenSeparatedCheckedHex(.versionedISAN).read(using: bitReader))
        case .tid:
            try validate(upidLength: upidLength, expectedLength: 12, upidType: upidType)
            self = .tid(bitReader.string(fromBytes: 12))
        case .ti:
            try validate(upidLength: upidLength, expectedLength: 8, upidType: upidType)
            self = .ti("0x\(bitReader.bytes(count: 8).map { String(format: "%02X", $0) }.joined())")
        case .adi:
            self = .adi(bitReader.string(fromBytes: UInt(upidLength)))
        case .eidr:
            try validate(upidLength: upidLength, expectedLength: 12, upidType: upidType)
            let decimal = "10.\(bitReader.uint16(fromBits: 16))"
            let hexComponents = HyphenSeparatedCheckedHex(.eidr).read(using: bitReader)
            self = .eidr("\(decimal)/\(hexComponents)")
        case .atscContentIdentifier:
            self = try .atscContentIdentifier(ATSCContentIdentifier(bitReader: bitReader, upidLength: upidLength))
        case .mpu:
            self = try .mpu(SegmentationDescriptor.ManagedPrivateUPID(bitReader: bitReader, upidLength: upidLength))
        case .mid:
            let bitsLeftAfterUPID = bitReader.bitsLeft - (Int(upidLength) * 8)
            var mid = [SegmentationDescriptor.SegmentationUPID]()
            while bitReader.bitsLeft > bitsLeftAfterUPID {
                try mid.append(SegmentationDescriptor.SegmentationUPID(bitReader: bitReader))
            }
            self = .mid(mid)
        case .adsInformation:
            self = .adsInformation(bitReader.string(fromBytes: UInt(upidLength)))
        case .uri:
            let urlString = bitReader.string(fromBytes: UInt(upidLength))
            guard let url = URL(string: urlString) else {
                throw ParserError.invalidURLInSegmentationUPID(urlString)
            }
            self = .uri(url)
        case .uuid:
            try validate(upidLength: upidLength, expectedLength: 16, upidType: upidType)
            let uuidString = bitReader.string(fromBytes: 16)
            guard let uuid = UUID(uuidString: uuidString) else {
                throw ParserError.invalidUUIDInSegmentationUPID(uuidString)
            }
            self = .uuid(uuid)
        }
    }
}

extension SegmentationDescriptor.ManagedPrivateUPID {
    init(bitReader: DataBitReader, upidLength: UInt8) throws {
        let privateDataLength = Int(upidLength) - 4
        guard privateDataLength >= 0 else {
            throw ParserError.invalidMPUInSegmentationUPID(
                InvalidMPUInSegmentationUPIDInfo(upidLength: Int(upidLength))
            )
        }
        let formatSpecifier = bitReader.string(fromBytes: 4)
        let privateData = Data(bitReader.bytes(count: privateDataLength))
        self.init(formatSpecifier: formatSpecifier, privateData: privateData)
    }
}

private func validate(
    upidLength: UInt8,
    expectedLength: Int,
    upidType: SegmentationDescriptor.SegmentationUPIDType
) throws {
    let declaredUPIDLength = Int(upidLength)
    guard declaredUPIDLength == expectedLength else {
        throw ParserError.unexpectedSegmentationUPIDLength(
            UnexpectedSegmentationUPIDLengthErrorInfo(
                declaredSegmentationUPIDLength: declaredUPIDLength,
                expectedSegmentationUPIDLength: expectedLength,
                segmentationUPIDType: upidType
            )
        )
    }
}

private struct HyphenSeparatedCheckedHex {
    enum Version {
        case deprecatedISAN
        case versionedISAN
        case eidr
    }
    let version: Version
    
    private let charArray = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    
    init(_ version: Version) {
        self.version = version
    }
    
    func read(using bitReader: DataBitReader) -> String {
        let checkIndices: [Int]
        let indexMax: Int
        switch version {
        case .deprecatedISAN:
            checkIndices = [4]
            indexMax = 4
        case .versionedISAN:
            checkIndices = [4, 7]
            indexMax = 7
        case .eidr:
            checkIndices = [5]
            indexMax = 5
        }
        return (0...indexMax)
            .reduce(into: [String]()) { isan, index in
                if checkIndices.contains(index) {
                    isan.append(checkChar(for: isan))
                } else {
                    isan.append(String(format: "%04X", bitReader.uint16(fromBits: 16)))
                }
            }
            .joined(separator: "-")
    }
    
    // The check calculation is taken from isan_check_digit_calculation_v2.0.pdf included
    // in the repository.
    private func checkChar(for isan: [String]) -> String {
        let isan = isan.filter { $0.count > 1 }
        let adjustedProduct = isan.joined().reduce(36) { adjustedSum, char in
            // The force unwrap should be safe here as we know that all non-check characters
            // in the ISAN array are formed out of hexadecimal numbers.
            let decimalValue = Int(String(char), radix: 16)!
            var sum = adjustedSum + decimalValue
            if sum > 36 { sum -= 36 }
            var product = sum * 2
            if product >= 37 { product -= 37 }
            return product
        }
        if adjustedProduct == 1 {
            return "0"
        } else {
            return String(charArray[37 - adjustedProduct])
        }
    }
}
