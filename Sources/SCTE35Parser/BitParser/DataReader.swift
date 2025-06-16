//
//  DataReader.swift
//
//
//  Created by Robert Galluccio on 01/05/2021.
//

import Foundation

class DataReader: DataBitReader, Equatable {
    static func == (lhs: DataReader, rhs: DataReader) -> Bool {
        return lhs.nonFatalErrors == rhs.nonFatalErrors &&
        lhs.isAligned == rhs.isAligned &&
        lhs.bitsLeft == rhs.bitsLeft &&
        lhs.bitsRead == rhs.bitsRead &&
        lhs.msbBitReader.data == rhs.msbBitReader.data
    }

    var nonFatalErrors = [ParserError]()
    var isAligned: Bool { msbBitReader.isAligned }
    var bitsLeft: Int { msbBitReader.bitsLeft }
    var bitsRead: Int { msbBitReader.bitsRead }

    private let msbBitReader: MsbBitReader

    required init(data: Data) {
        msbBitReader = MsbBitReader(data: data)
    }

    required init(_ byteReader: ByteReader) {
        msbBitReader = MsbBitReader(byteReader)
    }

    func bit() throws -> UInt8 {
        if msbBitReader.bitsLeft < 1 {
            throw ParserError.unexpectedEndOfData(
                UnexpectedEndOfDataErrorInfo(
                    expectedMinimumBitsLeft: 1,
                    actualBitsLeft: msbBitReader.bitsLeft,
                    description: "Trying to read bit"
                )
            )
        }
        return msbBitReader.bit()
    }

    func bits(count: Int) throws -> [UInt8] {
        if msbBitReader.bitsLeft < count {
            throw ParserError.unexpectedEndOfData(
                UnexpectedEndOfDataErrorInfo(
                    expectedMinimumBitsLeft: count,
                    actualBitsLeft: msbBitReader.bitsLeft,
                    description: "Trying to read bits"
                )
            )
        }
        return msbBitReader.bits(count: count)
    }

    func int(fromBits count: Int) throws -> Int {
        if msbBitReader.bitsLeft < count {
            throw ParserError.unexpectedEndOfData(
                UnexpectedEndOfDataErrorInfo(
                    expectedMinimumBitsLeft: count,
                    actualBitsLeft: msbBitReader.bitsLeft,
                    description: "Trying to read Int"
                )
            )
        }
        return msbBitReader.int(fromBits: count)
    }

    func byte(fromBits count: Int) throws -> UInt8 {
        if msbBitReader.bitsLeft < count {
            throw ParserError.unexpectedEndOfData(
                UnexpectedEndOfDataErrorInfo(
                    expectedMinimumBitsLeft: count,
                    actualBitsLeft: msbBitReader.bitsLeft,
                    description: "Trying to read byte"
                )
            )
        }
        return msbBitReader.byte(fromBits: count)
    }

    func uint16(fromBits count: Int) throws -> UInt16 {
        if msbBitReader.bitsLeft < count {
            throw ParserError.unexpectedEndOfData(
                UnexpectedEndOfDataErrorInfo(
                    expectedMinimumBitsLeft: count,
                    actualBitsLeft: msbBitReader.bitsLeft,
                    description: "Trying to read UInt16"
                )
            )
        }
        return msbBitReader.uint16(fromBits: count)
    }

    func uint32(fromBits count: Int) throws -> UInt32 {
        if msbBitReader.bitsLeft < count {
            throw ParserError.unexpectedEndOfData(
                UnexpectedEndOfDataErrorInfo(
                    expectedMinimumBitsLeft: count,
                    actualBitsLeft: msbBitReader.bitsLeft,
                    description: "Trying to read UInt32"
                )
            )
        }
        return msbBitReader.uint32(fromBits: count)
    }

    func uint64(fromBits count: Int) throws -> UInt64 {
        if msbBitReader.bitsLeft < count {
            throw ParserError.unexpectedEndOfData(
                UnexpectedEndOfDataErrorInfo(
                    expectedMinimumBitsLeft: count,
                    actualBitsLeft: msbBitReader.bitsLeft,
                    description: "Trying to read UInt64"
                )
            )
        }
        return msbBitReader.uint64(fromBits: count)
    }

    func align() {
        msbBitReader.align()
    }

    func byte() throws -> UInt8 {
        if msbBitReader.bitsLeft < 8 {
            throw ParserError.unexpectedEndOfData(
                UnexpectedEndOfDataErrorInfo(
                    expectedMinimumBitsLeft: 8,
                    actualBitsLeft: msbBitReader.bitsLeft,
                    description: "Trying to read byte"
                )
            )
        }
        return msbBitReader.byte()
    }

    func bytes(count: Int) throws -> [UInt8] {
        if msbBitReader.bitsLeft < (8 * count) {
            throw ParserError.unexpectedEndOfData(
                UnexpectedEndOfDataErrorInfo(
                    expectedMinimumBitsLeft: 8 * count,
                    actualBitsLeft: msbBitReader.bitsLeft,
                    description: "Trying to read bytes"
                )
            )
        }
        return msbBitReader.bytes(count: count)
    }

    func int(fromBytes count: Int) throws -> Int {
        if msbBitReader.bitsLeft < (8 * count) {
            throw ParserError.unexpectedEndOfData(
                UnexpectedEndOfDataErrorInfo(
                    expectedMinimumBitsLeft: 8 * count,
                    actualBitsLeft: msbBitReader.bitsLeft,
                    description: "Trying to read Int"
                )
            )
        }
        return msbBitReader.int(fromBytes: count)
    }

    func uint64() throws -> UInt64 {
        if msbBitReader.bitsLeft < 64 {
            throw ParserError.unexpectedEndOfData(
                UnexpectedEndOfDataErrorInfo(
                    expectedMinimumBitsLeft: 64,
                    actualBitsLeft: msbBitReader.bitsLeft,
                    description: "Trying to read UInt64"
                )
            )
        }
        return msbBitReader.uint64()
    }

    func uint64(fromBytes count: Int) throws -> UInt64 {
        if msbBitReader.bitsLeft < (8 * count) {
            throw ParserError.unexpectedEndOfData(
                UnexpectedEndOfDataErrorInfo(
                    expectedMinimumBitsLeft: 8 * count,
                    actualBitsLeft: msbBitReader.bitsLeft,
                    description: "Trying to read UInt64"
                )
            )
        }
        return msbBitReader.uint64(fromBytes: count)
    }

    func uint32() throws -> UInt32 {
        if msbBitReader.bitsLeft < 32 {
            throw ParserError.unexpectedEndOfData(
                UnexpectedEndOfDataErrorInfo(
                    expectedMinimumBitsLeft: 32,
                    actualBitsLeft: msbBitReader.bitsLeft,
                    description: "Trying to read UInt32"
                )
            )
        }
        return msbBitReader.uint32()
    }

    func uint32(fromBytes count: Int) throws -> UInt32 {
        if msbBitReader.bitsLeft < (8 * count) {
            throw ParserError.unexpectedEndOfData(
                UnexpectedEndOfDataErrorInfo(
                    expectedMinimumBitsLeft: 8 * count,
                    actualBitsLeft: msbBitReader.bitsLeft,
                    description: "Trying to read UInt32"
                )
            )
        }
        return msbBitReader.uint32(fromBytes: count)
    }

    func uint16() throws -> UInt16 {
        if msbBitReader.bitsLeft < 16 {
            throw ParserError.unexpectedEndOfData(
                UnexpectedEndOfDataErrorInfo(
                    expectedMinimumBitsLeft: 16,
                    actualBitsLeft: msbBitReader.bitsLeft,
                    description: "Trying to read UInt16"
                )
            )
        }
        return msbBitReader.uint16()
    }

    func uint16(fromBytes count: Int) throws -> UInt16 {
        if msbBitReader.bitsLeft < (8 * count) {
            throw ParserError.unexpectedEndOfData(
                UnexpectedEndOfDataErrorInfo(
                    expectedMinimumBitsLeft: 8 * count,
                    actualBitsLeft: msbBitReader.bitsLeft,
                    description: "Trying to read UInt16"
                )
            )
        }
        return msbBitReader.uint16(fromBytes: count)
    }

}
