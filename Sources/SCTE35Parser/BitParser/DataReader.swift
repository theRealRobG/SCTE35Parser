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
    
    func bit() -> UInt8 {
        msbBitReader.bit()
    }
    
    func bits(count: Int) -> [UInt8] {
        msbBitReader.bits(count: count)
    }
    
    func int(fromBits count: Int) -> Int {
        msbBitReader.int(fromBits: count)
    }
    
    func byte(fromBits count: Int) -> UInt8 {
        msbBitReader.byte(fromBits: count)
    }
    
    func uint16(fromBits count: Int) -> UInt16 {
        msbBitReader.uint16(fromBits: count)
    }
    
    func uint32(fromBits count: Int) -> UInt32 {
        msbBitReader.uint32(fromBits: count)
    }
    
    func uint64(fromBits count: Int) -> UInt64 {
        msbBitReader.uint64(fromBits: count)
    }
    
    func align() {
        msbBitReader.align()
    }
    
    func byte() -> UInt8 {
        msbBitReader.byte()
    }
    
    func bytes(count: Int) -> [UInt8] {
        msbBitReader.bytes(count: count)
    }
    
    func int(fromBytes count: Int) -> Int {
        msbBitReader.int(fromBytes: count)
    }
    
    func uint64() -> UInt64 {
        msbBitReader.uint64()
    }
    
    func uint64(fromBytes count: Int) -> UInt64 {
        msbBitReader.uint64(fromBytes: count)
    }
    
    func uint32() -> UInt32 {
        msbBitReader.uint32()
    }
    
    func uint32(fromBytes count: Int) -> UInt32 {
        msbBitReader.uint32(fromBytes: count)
    }
    
    func uint16() -> UInt16 {
        msbBitReader.uint16()
    }
    
    func uint16(fromBytes count: Int) -> UInt16 {
        msbBitReader.uint16(fromBytes: count)
    }
    
}
