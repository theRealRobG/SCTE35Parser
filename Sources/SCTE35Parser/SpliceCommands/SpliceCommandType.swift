//
//  SpliceCommandType.swift
//  
//
//  Created by Robert Galluccio on 30/01/2021.
//

public enum SpliceCommandType: UInt8 {
    case spliceNull = 0x00
    case spliceSchedule = 0x04
    case spliceInsert = 0x05
    case timeSignal = 0x06
    case bandwidthReservation = 0x07
    case privateCommand = 0xff
}
