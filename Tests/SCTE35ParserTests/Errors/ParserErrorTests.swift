//
//  ParserErrorTests.swift
//  
//
//  Created by Robert Galluccio on 21/04/2021.
//

import Foundation
import XCTest
import SCTE35Parser

class ParserErrorTests: XCTestCase {
    var expectedError: ParserError!
    
    func test_initFromNSError_encryptedMessageNotSupported() {
        expectedError = .encryptedMessageNotSupported
        XCTAssertEqual(expectedError, ParserError(fromNSError: expectedError as NSError))
    }
    
    func test_initFromNSError_invalidATSCContentIdentifierInUPID() {
        expectedError = .invalidATSCContentIdentifierInUPID(
            InvalidATSCContentIdentifierInUPIDInfo(upidLength: 10)
        )
        XCTAssertEqual(expectedError, ParserError(fromNSError: expectedError as NSError))
    }
    
    func test_initFromNSError_invalidBitStreamMode() {
        expectedError = .invalidBitStreamMode(InvalidBitStreamModeErrorInfo(bsmod: 7, acmod: nil))
        XCTAssertEqual(expectedError, ParserError(fromNSError: expectedError as NSError))
    }
    
    func test_initFromNSError_invalidInputString() {
        expectedError = .invalidInputString("!*&@$%?")
        XCTAssertEqual(expectedError, ParserError(fromNSError: expectedError as NSError))
    }
    
    func test_initFromNSError_invalidMPUInSegmentationUPID() {
        expectedError = .invalidMPUInSegmentationUPID(InvalidMPUInSegmentationUPIDInfo(upidLength: 8))
        XCTAssertEqual(expectedError, ParserError(fromNSError: expectedError as NSError))
    }
    
    func test_initFromNSError_invalidPrivateIndicator() {
        expectedError = .invalidPrivateIndicator
        XCTAssertEqual(expectedError, ParserError(fromNSError: expectedError as NSError))
    }
    
    func test_initFromNSError_invalidSectionSyntaxIndicator() {
        expectedError = .invalidSectionSyntaxIndicator
        XCTAssertEqual(expectedError, ParserError(fromNSError: expectedError as NSError))
    }
    
    func test_initFromNSError_invalidSegmentationDescriptorIdentifier() {
        expectedError = .invalidSegmentationDescriptorIdentifier(42)
        XCTAssertEqual(expectedError, ParserError(fromNSError: expectedError as NSError))
    }
    
    func test_initFromNSError_invalidURLInSegmentationUPID() {
        expectedError = .invalidURLInSegmentationUPID("")
        XCTAssertEqual(expectedError, ParserError(fromNSError: expectedError as NSError))
    }
    
    func test_initFromNSError_invalidUUIDInSegmentationUPID() {
        expectedError = .invalidUUIDInSegmentationUPID("")
        XCTAssertEqual(expectedError, ParserError(fromNSError: expectedError as NSError))
    }
    
    func test_initFromNSError_unexpectedEndOfData() {
        expectedError = .unexpectedEndOfData(
            UnexpectedEndOfDataErrorInfo(
                expectedMinimumBitsLeft: 100,
                actualBitsLeft: 50,
                description: "Oops"
            )
        )
        XCTAssertEqual(expectedError, ParserError(fromNSError: expectedError as NSError))
    }
    
    func test_initFromNSError_unexpectedSegmentationUPIDLength() {
        expectedError = .unexpectedSegmentationUPIDLength(
            UnexpectedSegmentationUPIDLengthErrorInfo(
                declaredSegmentationUPIDLength: 8,
                expectedSegmentationUPIDLength: 12,
                segmentationUPIDType: .ti
            )
        )
        XCTAssertEqual(expectedError, ParserError(fromNSError: expectedError as NSError))
    }
    
    func test_initFromNSError_unrecognisedAudioCodingMode() {
        expectedError = .unrecognisedAudioCodingMode(10)
        XCTAssertEqual(expectedError, ParserError(fromNSError: expectedError as NSError))
    }
    
    func test_initFromNSError_unrecognisedSegmentationTypeID() {
        expectedError = .unrecognisedSegmentationTypeID(0x55)
        XCTAssertEqual(expectedError, ParserError(fromNSError: expectedError as NSError))
    }
    
    func test_initFromNSError_unrecognisedSegmentationUPIDType() {
        expectedError = .unrecognisedSegmentationUPIDType(0x22)
        XCTAssertEqual(expectedError, ParserError(fromNSError: expectedError as NSError))
    }
    
    func test_initFromNSError_unrecognisedSpliceCommandType() {
        expectedError = .unrecognisedSpliceCommandType(0x10)
        XCTAssertEqual(expectedError, ParserError(fromNSError: expectedError as NSError))
    }
    
    func test_initFromNSError_unrecognisedSpliceDescriptorTag() {
        expectedError = .unrecognisedSpliceDescriptorTag(0x10)
        XCTAssertEqual(expectedError, ParserError(fromNSError: expectedError as NSError))
    }
    
    func test_initFromNSError_unexpectedSpliceCommandLength() {
        expectedError = .unexpectedSpliceCommandLength(
            UnexpectedSpliceCommandLengthErrorInfo(
                declaredSpliceCommandLengthInBits: 16,
                actualSpliceCommandLengthInBits: 32,
                spliceCommandType: .timeSignal
            )
        )
        XCTAssertEqual(expectedError, ParserError(fromNSError: expectedError as NSError))
    }
    
    func test_initFromNSError_unexpectedDescriptorLoopLength() {
        expectedError = .unexpectedDescriptorLoopLength(
            UnexpectedDescriptorLoopLengthErrorInfo(
                declaredDescriptorLoopLengthInBits: 32,
                actualDescriptorLoopLengthInBits: 64
            )
        )
        XCTAssertEqual(expectedError, ParserError(fromNSError: expectedError as NSError))
    }
    
    func test_initFromNSError_unexpectedSpliceDescriptorLength() {
        expectedError = .unexpectedSpliceDescriptorLength(
            UnexpectedSpliceDescriptorLengthErrorInfo(
                declaredSpliceDescriptorLengthInBits: 16,
                actualSpliceDescriptorLengthInBits: 32,
                spliceDescriptorTag: .availDescriptor
            )
        )
        XCTAssertEqual(expectedError, ParserError(fromNSError: expectedError as NSError))
    }
}
