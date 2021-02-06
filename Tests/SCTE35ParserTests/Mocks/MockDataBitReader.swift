//
//  MockDataBitReader.swift
//  
//
//  Created by Robert Galluccio on 06/02/2021.
//

@testable import SCTE35Parser
import BitByteData
import Foundation

class MockDataBitReader: DataBitReader {
    // MARK: - Function listeners
    
    var bitListener: (() -> Void)?
    var bitsCountListener: ((Int) -> Void)?
    var intFromBitsListener: ((Int) -> Void)?
    var byteFromBitsListener: ((Int) -> Void)?
    var uint16FromBitsListener: ((Int) -> Void)?
    var uint32FromBitsListener: ((Int) -> Void)?
    var uint64FromBitsListener: ((Int) -> Void)?
    var alignListener: (() -> Void)?
    var byteListener: (() -> Void)?
    var bytesCountListener: ((Int) -> Void)?
    var intFromBytesListener: ((Int) -> Void)?
    var uint64Listener: (() -> Void)?
    var uint64FromBytesListener: ((Int) -> Void)?
    var uint32Listener: (() -> Void)?
    var uint32FromBytesListener: ((Int) -> Void)?
    var uint16Listener: (() -> Void)?
    var uint16FromBytesListener: ((Int) -> Void)?
    var validateListener: ((Int, String) -> Void)?
    
    // MARK: - Function fake return values
    
    var bitReturnValue: UInt8 = 0
    var bitsCountReturnValue: [UInt8] = []
    var intFromBitsReturnValue: Int = 0
    var byteFromBitsReturnValue: UInt8 = 0
    var uint16FromBitsReturnValue: UInt16 = 0
    var uint32FromBitsReturnValue: UInt32 = 0
    var uint64FromBitsReturnValue: UInt64 = 0
    var byteReturnValue: UInt8 = 0
    var bytesCountReturnValue: [UInt8] = []
    var intFromBytesReturnValue: Int = 0
    var uint64ReturnValue: UInt64 = 0
    var uint64FromBytesReturnValue: UInt64 = 0
    var uint32ReturnValue: UInt32 = 0
    var uint32FromBytesReturnValue: UInt32 = 0
    var uint16ReturnValue: UInt16 = 0
    var uint16FromBytesReturnValue: UInt16 = 0
    
    // MARK: - Error factories
    
    var validateErrorFactory: (Int, String) -> Error? = { _, _ in nil }
    
    // MARK: - Property listeners
    
    var isAlignedGetListener: (() -> Void)?
    var isAlignedSetListener: ((Bool) -> Void)?
    var bitsLeftGetListener: (() -> Void)?
    var bitsLeftSetListener: ((Int) -> Void)?
    var bitsReadGetListener: (() -> Void)?
    var bitsReadSetListener: ((Int) -> Void)?
    
    // MARK: - Fake properties
    
    var fakeIsAligned = true
    var fakeBitsLeft = 0
    var fakeBitsRead = 0
    let initData: Data?
    let initByteReader: ByteReader?
    
    // MARK: - Protocol implementation
    
    var isAligned: Bool {
        get {
            isAlignedGetListener?()
            return fakeIsAligned
        }
        set {
            isAlignedSetListener?(newValue)
        }
    }
    var bitsLeft: Int {
        get {
            bitsLeftGetListener?()
            return fakeBitsLeft
        }
        set {
            bitsLeftSetListener?(newValue)
        }
    }
    var bitsRead: Int {
        get {
            bitsReadGetListener?()
            return fakeBitsRead
        }
        set {
            bitsReadSetListener?(newValue)
        }
    }
    
    required init(data: Data) {
        initData = data
        initByteReader = nil
    }
    
    required init(_ byteReader: ByteReader) {
        initByteReader = byteReader
        initData = nil
    }
    
    func bit() -> UInt8 {
        bitListener?()
        return bitReturnValue
    }
    
    func bits(count: Int) -> [UInt8] {
        bitsCountListener?(count)
        return bitsCountReturnValue
    }
    
    func int(fromBits count: Int) -> Int {
        intFromBitsListener?(count)
        return intFromBitsReturnValue
    }
    
    func byte(fromBits count: Int) -> UInt8 {
        byteFromBitsListener?(count)
        return byteFromBitsReturnValue
    }
    
    func uint16(fromBits count: Int) -> UInt16 {
        uint16FromBitsListener?(count)
        return uint16FromBitsReturnValue
    }
    
    func uint32(fromBits count: Int) -> UInt32 {
        uint32FromBitsListener?(count)
        return uint32FromBitsReturnValue
    }
    
    func uint64(fromBits count: Int) -> UInt64 {
        uint64FromBitsListener?(count)
        return uint64FromBitsReturnValue
    }
    
    func align() {
        alignListener?()
    }
    
    func byte() -> UInt8 {
        byteListener?()
        return byteReturnValue
    }
    
    func bytes(count: Int) -> [UInt8] {
        bytesCountListener?(count)
        return bytesCountReturnValue
    }
    
    func int(fromBytes count: Int) -> Int {
        intFromBytesListener?(count)
        return intFromBytesReturnValue
    }
    
    func uint64() -> UInt64 {
        uint64Listener?()
        return uint64ReturnValue
    }
    
    func uint64(fromBytes count: Int) -> UInt64 {
        uint64FromBytesListener?(count)
        return uint64FromBytesReturnValue
    }
    
    func uint32() -> UInt32 {
        uint32Listener?()
        return uint32ReturnValue
    }
    
    func uint32(fromBytes count: Int) -> UInt32 {
        uint32FromBytesListener?(count)
        return uint32FromBytesReturnValue
    }
    
    func uint16() -> UInt16 {
        uint16Listener?()
        return uint16ReturnValue
    }
    
    func uint16(fromBytes count: Int) -> UInt16 {
        uint16FromBytesListener?(count)
        return uint16FromBytesReturnValue
    }
    
    func validate(expectedMinimumBitsLeft: Int, parseDescription: String) throws {
        validateListener?(expectedMinimumBitsLeft, parseDescription)
        if let error = validateErrorFactory(expectedMinimumBitsLeft, parseDescription) {
            throw error
        }
    }
}
