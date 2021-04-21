//
//  File.swift
//  
//
//  Created by Robert Galluccio on 31/03/2021.
//

public struct InvalidMPUInSegmentationUPIDInfo: Equatable {
    public let upidLength: Int
    public let staticBytesLength = 4
    public var calculatedPrivateDataByteCount: Int { upidLength - staticBytesLength }
    
    public init(upidLength: Int) {
        self.upidLength = upidLength
    }
}
