//
//  ParserError+Code.swift
//  
//
//  Created by Robert Galluccio on 06/02/2021.
//

public extension ParserError {
    enum Code: Int {
        case unexpectedEndOfData
        case invalidInputString
        case invalidSectionSyntaxIndicator
        case invalidPrivateIndicator
        case unrecognisedSpliceCommandType
        case unrecognisedSegmentationUPIDType
        case unexpectedSegmentationUPIDLength
        case invalidUUIDInSegmentationUPID
        case invalidURLInSegmentationUPID
        case unrecognisedSegmentationTypeID
        case invalidSegmentationDescriptorIdentifier
        case invalidATSCContentIdentifierInUPID
        case invalidMPUInSegmentationUPID
        case invalidBitStreamMode
        case unrecognisedAudioCodingMode
    }
}
