//
//  BreakDurationTests.swift
//  
//
//  Created by Robert Galluccio on 06/02/2021.
//

@testable import SCTE35Parser
import XCTest

class BreakDurationTests: XCTestCase {
    var mockBitReader: MockDataBitReader!
    
    override func setUp() {
        mockBitReader = MockDataBitReader()
    }
    
    func test_init_shouldValidateFor40BitsThenReadRest() throws {
        let validateExp = expectation(description: "wait for validate 40 bits")
        let readBitExp = expectation(description: "wait for read bit")
        let read6BitsExp = expectation(description: "wait for read 6 bits")
        let read33BitsExp = expectation(description: "wait for read 33 bits")
        
        let expectedAutoReturn = true
        mockBitReader.bitReturnValue = 1
        let expectedDuration: UInt64 = 100
        mockBitReader.uint64FromBitsReturnValue = expectedDuration
        
        mockBitReader.validateListener = { bits, _ in
            XCTAssertEqual(40, bits)
            validateExp.fulfill()
        }
        
        mockBitReader.bitListener = {
            readBitExp.fulfill()
        }
        
        mockBitReader.bitsCountListener = { count in
            XCTAssertEqual(6, count)
            read6BitsExp.fulfill()
        }
        
        mockBitReader.uint64FromBitsListener = { count in
            XCTAssertEqual(33, count)
            read33BitsExp.fulfill()
        }
        
        let breakDuration = try BreakDuration(bitReader: mockBitReader)
        XCTAssertEqual(expectedAutoReturn, breakDuration.autoReturn)
        XCTAssertEqual(expectedDuration, breakDuration.duration)
        
        wait(
            for: [
                validateExp,
                readBitExp,
                read6BitsExp,
                read33BitsExp
            ],
            timeout: 0.1,
            enforceOrder: true
        )
    }
}
