//
//  SpliceDescriptorTag.swift
//  
//
//  Created by Robert Galluccio on 30/01/2021.
//

public enum SpliceDescriptorTag: UInt8 {
    case availDescriptor = 0x00
    case dtmfDescriptor = 0x01
    case segmentationDescriptor = 0x02
    case timeDescriptor = 0x03
    case audioDescriptor = 0x04
}
