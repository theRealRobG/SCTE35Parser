//
//  SpliceTimeTests.swift
//  
//
//  Created by Robert Galluccio on 06/02/2021.
//

@testable import SCTE35Parser
import XCTest

class SpliceTimeTests: XCTestCase {
    var mockBitReader: MockDataBitReader!
    
    override func setUp() {
        mockBitReader = MockDataBitReader()
    }
    
    func test_init_whenValidateThrows_shouldThrow() {
        let expectedError: ParserError = .unexpectedEndOfData(.stub())
        mockBitReader.validateErrorFactory = { _, _ in expectedError }
        XCTAssertThrowsError(try SpliceTime(bitReader: mockBitReader)) { error in
            guard let error = error as? ParserError else { return XCTFail() }
            XCTAssertEqual(expectedError, error)
        }
    }
    
    func test_init_shouldValidateBeforeCheckingTimeSpecifiedFlag() throws {
        let validateExp = expectation(description: "wait for validate 1 bit")
        let readBitExp = expectation(description: "wait for read 1 bit")
        
        var validateCallCount = 0
        mockBitReader.validateListener = { bits, _ in
            validateCallCount += 1
            guard validateCallCount == 1 else { return }
            XCTAssertEqual(1, bits)
            validateExp.fulfill()
        }
        
        var readBitCallCount = 0
        mockBitReader.bitListener = {
            readBitCallCount += 1
            guard readBitCallCount == 1 else { return }
            readBitExp.fulfill()
        }
        
        _ = try SpliceTime(bitReader: mockBitReader)
        
        wait(
            for: [
                validateExp,
                readBitExp
            ],
            timeout: 0.1,
            enforceOrder: true
        )
    }
    
    func test_init_whenTimeSpecified_shouldValidateFor39BitsThenRead6BitsThen33BitsForTimeValue() throws {
        let validateExp = expectation(description: "wait for validate 39 bits")
        let read6BitsExp = expectation(description: "wait for read 6 bits")
        let read33BitsExp = expectation(description: "wait for read 33 bits")
        
        let expectedTime: UInt64 = 100
        mockBitReader.uint64FromBitsReturnValue = expectedTime
        mockBitReader.bitReturnValue = 1
        
        var validateCallCount = 0
        mockBitReader.validateListener = { bits, _ in
            validateCallCount += 1
            guard validateCallCount == 2 else { return }
            XCTAssertEqual(39, bits)
            validateExp.fulfill()
        }
        
        mockBitReader.bitsCountListener = { count in
            XCTAssertEqual(6, count)
            read6BitsExp.fulfill()
        }
        
        mockBitReader.uint64FromBitsListener = { count in
            XCTAssertEqual(33, count)
            read33BitsExp.fulfill()
        }
        
        let spliceTime = try SpliceTime(bitReader: mockBitReader)
        XCTAssertEqual(expectedTime, spliceTime.ptsTime)
        
        wait(
            for: [
                validateExp,
                read6BitsExp,
                read33BitsExp
            ],
            timeout: 0.1,
            enforceOrder: true
        )
    }
    
    func test_init_whenTimeNotSpecified_shouldValidateFor7BitsThenRead7Bits() throws {
        let validateExp = expectation(description: "wait for validate 39 bits")
        let read7BitsExp = expectation(description: "wait for read 7 bits")
        
        mockBitReader.bitReturnValue = 0
        
        var validateCallCount = 0
        mockBitReader.validateListener = { bits, _ in
            validateCallCount += 1
            guard validateCallCount == 2 else { return }
            XCTAssertEqual(7, bits)
            validateExp.fulfill()
        }
        
        mockBitReader.bitsCountListener = { count in
            XCTAssertEqual(7, count)
            read7BitsExp.fulfill()
        }
        
        let spliceTime = try SpliceTime(bitReader: mockBitReader)
        XCTAssertNil(spliceTime.ptsTime)
        
        wait(
            for: [
                validateExp,
                read7BitsExp
            ],
            timeout: 0.1,
            enforceOrder: true
        )
    }
}
