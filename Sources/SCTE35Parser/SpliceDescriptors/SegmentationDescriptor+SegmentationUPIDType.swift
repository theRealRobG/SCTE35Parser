//
//  SegmentationDescriptor+SegmentationUPIDType.swift
//  
//
//  Created by Robert Galluccio on 30/01/2021.
//

public extension SegmentationDescriptor {
    /// There are multiple types allowed to ensure that programmers will be able to use an id that their
    /// systems support. It is expected that the consumers of these ids will have an out-of-band method
    /// of collecting other data related to these numbers and therefore they do not need to be of
    /// identical types. These ids may be in other descriptors in the Program and, where the same
    /// identifier is used (ISAN for example), it shall match between Programs.
    enum SegmentationUPIDType: UInt8 {
        case notUsed = 0x00
        case userDefined = 0x01
        case isci = 0x02
        case adID = 0x03
        case umid = 0x04
        case deprecatedISAN = 0x05
        case isan = 0x06
        case tid = 0x07
        case ti = 0x08
        case adi = 0x09
        case eidr = 0x0A
        case atscContentIdentifier = 0x0B
        case mpu = 0x0C
        case mid = 0x0D
        case adsInformation = 0x0E
        case uri = 0x0F
        case uuid = 0x10
    }
}
