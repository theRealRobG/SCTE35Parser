//
//  ParserError.swift
//  
//
//  Created by Robert Galluccio on 06/02/2021.
//

import Foundation

public enum ParserError: Equatable, LocalizedError, CustomNSError {
    case unexpectedEndOfData(UnexpectedEndOfDataErrorInfo)
    case invalidInputString(String)
    case invalidSectionSyntaxIndicator
    case invalidPrivateIndicator
    case unrecognisedSpliceCommandType(Int)
    case unrecognisedSegmentationUPIDType(Int)
    case unexpectedSegmentationUPIDLength(UnexpectedSegmentationUPIDLengthErrorInfo)
    case invalidUUIDInSegmentationUPID(String)
    case invalidURLInSegmentationUPID(String)
    case unrecognisedSegmentationTypeID(Int)
    case invalidSegmentationDescriptorIdentifier(Int)
    case invalidATSCContentIdentifierInUPID(InvalidATSCContentIdentifierInUPIDInfo)
    case invalidMPUInSegmentationUPID(InvalidMPUInSegmentationUPIDInfo)
    case invalidBitStreamMode(InvalidBitStreamModeErrorInfo)
    case unrecognisedAudioCodingMode(Int)
    case unrecognisedSpliceDescriptorTag(Int)
    
    public static var errorDomain: String { "SCTE35ParserError" }
    
    public static var unexpectedEndOfDataUserInfoKey: String { "unexpectedEndOfDataUserInfoKey" }
    public static var invalidInputStringUserInfoKey: String { "invalidUserInputUserInfoKey" }
    public static var unrecognisedSpliceCommandTypeUserInfoKey: String { "unrecognisedSpliceCommandTypeUserInfokey" }
    public static var unrecognisedSegmentationUPIDTypeUserInfoKey: String { "unrecognisedSegmentationUPIDTypeUserInfoKey" }
    public static var invalidUUIDInSegmentationUPIDUserInfoKey: String { "invalidUUIDInSegmentationUPIDUserInfoKey" }
    public static var invalidURLInSegmentationUPIDUserInfoKey: String { "invalidURLInSegmentationUPIDUserInfoKey" }
    public static var unrecognisedSegmentationTypeIDUserInfoKey: String { "unrecognisedSegmentationTypeIDUserInfoKey" }
    public static var unexpectedSegmentationUPIDLengthUserInfoKey: String { "unexpectedSegmentationUPIDLengthUserInfoKey" }
    public static var invalidSegmentationDescriptorIdentifierUserInfoKey: String { "invalidSegmentationDescriptorIdentifierUserInfoKey" }
    public static var invalidATSCContentIdentifierInUPIDUserInfoKey: String { "invalidATSCContentIdentifierInUPIDUserInfoKey" }
    public static var invalidMPUInSegmentationUPIDUserInfoKey: String { "invalidMPUInSegmentationUPIDUserInfoKey" }
    public static var invalidBitStreamModeUserInfoKey: String { "invalidBitStreamModeUserInfoKey" }
    public static var unrecognisedAudioCodingModeUserInfoKey: String { "unrecognisedAudioCodingModeUserInfoKey" }
    public static var unrecognisedSpliceDescriptorTagUserInfoKey: String { "unrecognisedSpliceDescriptorTagUserInfoKey" }
    
    public var code: Code {
        switch self {
        case .unexpectedEndOfData: return .unexpectedEndOfData
        case .invalidInputString: return .invalidInputString
        case .invalidSectionSyntaxIndicator: return .invalidSectionSyntaxIndicator
        case .invalidPrivateIndicator: return .invalidPrivateIndicator
        case .unrecognisedSpliceCommandType: return .unrecognisedSpliceCommandType
        case .unrecognisedSegmentationUPIDType: return .unrecognisedSegmentationUPIDType
        case .unexpectedSegmentationUPIDLength: return .unexpectedSegmentationUPIDLength
        case .invalidUUIDInSegmentationUPID: return .invalidUUIDInSegmentationUPID
        case .invalidURLInSegmentationUPID: return .invalidURLInSegmentationUPID
        case .unrecognisedSegmentationTypeID: return .unrecognisedSegmentationTypeID
        case .invalidSegmentationDescriptorIdentifier: return .invalidSegmentationDescriptorIdentifier
        case .invalidATSCContentIdentifierInUPID: return .invalidATSCContentIdentifierInUPID
        case .invalidMPUInSegmentationUPID: return .invalidMPUInSegmentationUPID
        case .invalidBitStreamMode: return .invalidBitStreamMode
        case .unrecognisedAudioCodingMode: return .unrecognisedAudioCodingMode
        case .unrecognisedSpliceDescriptorTag: return .unrecognisedSpliceDescriptorTag
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .unexpectedEndOfData:
            return "Unexpected end of data during parsing."
        case .invalidInputString:
            return "String input could not be converted to Data."
        case .invalidSectionSyntaxIndicator:
            return "Invalid section syntax indicator."
        case .invalidPrivateIndicator:
            return "Invalid private indicator."
        case .unrecognisedSpliceCommandType(let type):
            return "\(type) is an invalid splice command type."
        case .unrecognisedSegmentationUPIDType(let type):
            return "\(type) is an invalid segmentation upid type."
        case .unexpectedSegmentationUPIDLength:
            return "Unexpected mis-match between declared segmentation upid length and upid type."
        case .invalidUUIDInSegmentationUPID:
            return "The uuid string read from the segmentation upid was not a valid UUID."
        case .invalidURLInSegmentationUPID:
            return "The url string read from the segmentation upid was not a valid URL."
        case .unrecognisedSegmentationTypeID(let type):
            return "\(type) is an invalid segmentation type id."
        case .invalidSegmentationDescriptorIdentifier:
            return "Invalid segmentation descriptor identifier (was not 0x43554549)."
        case .invalidATSCContentIdentifierInUPID:
            return "Invalid upid length defined for ATSC content identifier."
        case .invalidMPUInSegmentationUPID:
            return "Invalid upid length defined for MPU."
        case .invalidBitStreamMode(let info):
            var acmodString = "nil"
            if let acmod = info.acmod {
                acmodString = "\(acmod)"
            }
            return "\(info.bsmod) bit stream mode and \(acmodString) audio coding mode is an invalid combination."
        case .unrecognisedAudioCodingMode(let type):
            return "\(type) is an invalid audio coding mode."
        case .unrecognisedSpliceDescriptorTag(let type):
            return "\(type) is an invalid splice descriptor tag."
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .unexpectedEndOfData(let info):
            return "Expected at least \(info.expectedMinimumBitsLeft) bits left and instead was \(info.actualBitsLeft) when parsing: \(info.description)."
        case .invalidInputString(let input):
            return "String could not be converted to Data: \(input)"
        case .invalidSectionSyntaxIndicator:
            return "The 1-bit section syntax indicator was not 0."
        case .invalidPrivateIndicator:
            return "The 1-bit private indicator was not 0."
        case .unrecognisedSpliceCommandType(let type):
            return "Value \(type) was obtained for splice command type and this does not match any known values."
        case .unrecognisedSegmentationUPIDType(let type):
            return "Value \(type) was obtained for segmentation upid type and this does not match any known values."
        case .unexpectedSegmentationUPIDLength(let info):
            return "Declared upid length was \(info.declaredSegmentationUPIDLength); however, expected length for upid type \(info.segmentationUPIDType) is \(info.expectedSegmentationUPIDLength)."
        case .invalidUUIDInSegmentationUPID(let uuidString):
            return "\(uuidString) is not a valid UUID."
        case .invalidURLInSegmentationUPID(let urlString):
            return "\(urlString) is not a valid URL."
        case .unrecognisedSegmentationTypeID(let type):
            return "Value \(type) was obtained for segmentation type id and this does not match any known values."
        case .invalidSegmentationDescriptorIdentifier(let value):
            return "Value \(value) was obtained for segmentation descriptor identifier but this should be 0x43554549."
        case .invalidATSCContentIdentifierInUPID(let info):
            return "UPID length defined as \(info.upidLength), and \(info.staticBytesLength) bytes are taken up by static fields, implying contentID has \(info.calculatedContentIDByteCount) bytes left, which is invalid."
        case .invalidMPUInSegmentationUPID(let info):
            return "UPID length defined as \(info.upidLength), and \(info.staticBytesLength) bytes are taken up by static fields, implying private data has \(info.calculatedPrivateDataByteCount) bytes left, which is invalid."
        case .invalidBitStreamMode(let info):
            var acmodString = "nil"
            if let acmod = info.acmod {
                acmodString = "\(acmod)"
            }
            return "Value \(info.bsmod) was obtained for bit stream mode, and \(acmodString) was obtained for audio coding mode, but this combination is not a valid BitStreamMode."
        case .unrecognisedAudioCodingMode(let type):
            return "Value \(type) was obtained for audio coding mode and this does not match any known values."
        case .unrecognisedSpliceDescriptorTag(let type):
            return "Value \(type) was obtained for splice descriptor tag and this does not match any known values."
        }
    }
    
    public var errorCode: Int { code.rawValue }
    
    public var errorUserInfo: [String: Any] {
        switch self {
        case .unexpectedEndOfData(let info): return [Self.unexpectedEndOfDataUserInfoKey: info]
        case .invalidInputString(let input): return [Self.invalidInputStringUserInfoKey: input]
        case .invalidSectionSyntaxIndicator: return [:]
        case .invalidPrivateIndicator: return [:]
        case .unrecognisedSpliceCommandType(let type): return [Self.unrecognisedSpliceCommandTypeUserInfoKey: type]
        case .unrecognisedSegmentationUPIDType(let type): return [Self.unrecognisedSegmentationUPIDTypeUserInfoKey: type]
        case .unexpectedSegmentationUPIDLength(let info): return [Self.unexpectedSegmentationUPIDLengthUserInfoKey: info]
        case .invalidUUIDInSegmentationUPID(let uuidString): return [Self.invalidUUIDInSegmentationUPIDUserInfoKey: uuidString]
        case .invalidURLInSegmentationUPID(let urlString): return [Self.invalidURLInSegmentationUPIDUserInfoKey: urlString]
        case .unrecognisedSegmentationTypeID(let type): return [Self.unrecognisedSegmentationTypeIDUserInfoKey: type]
        case .invalidSegmentationDescriptorIdentifier(let value): return [Self.invalidSegmentationDescriptorIdentifierUserInfoKey: value]
        case .invalidATSCContentIdentifierInUPID(let info): return [Self.invalidATSCContentIdentifierInUPIDUserInfoKey: info]
        case .invalidMPUInSegmentationUPID(let info): return [Self.invalidMPUInSegmentationUPIDUserInfoKey: info]
        case .invalidBitStreamMode(let info): return [Self.invalidBitStreamModeUserInfoKey: info]
        case .unrecognisedAudioCodingMode(let type): return [Self.unrecognisedAudioCodingModeUserInfoKey: type]
        case .unrecognisedSpliceDescriptorTag(let type): return [Self.unrecognisedSpliceDescriptorTagUserInfoKey: type]
        }
    }
}
