//
//  ParserError+Code.swift
//  
//
//  Created by Robert Galluccio on 06/02/2021.
//

public extension ParserError {
    enum Code: Int {
        case encryptedMessageNotSupported = 0
        case invalidATSCContentIdentifierInUPID = 100
        case invalidBitStreamMode = 101
        case invalidInputString = 102
        case invalidMPUInSegmentationUPID = 103
        case invalidPrivateIndicator = 104
        case invalidSectionSyntaxIndicator = 105
        case invalidSegmentationDescriptorIdentifier = 106
        case invalidURLInSegmentationUPID = 107
        case invalidUUIDInSegmentationUPID = 108
        case unexpectedEndOfData = 200
        case unexpectedSegmentationUPIDLength = 201
        case unexpectedSpliceCommandLength = 202
        case unexpectedDescriptorLoopLength = 203
        case unexpectedSpliceDescriptorLength = 204
        case unrecognisedAudioCodingMode = 300
        case unrecognisedSegmentationTypeID = 301
        case unrecognisedSegmentationUPIDType = 302
        case unrecognisedSpliceCommandType = 303
        case unrecognisedSpliceDescriptorTag = 304
    }
}
