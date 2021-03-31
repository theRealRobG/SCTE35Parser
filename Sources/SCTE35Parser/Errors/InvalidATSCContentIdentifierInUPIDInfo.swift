//
//  InvalidATSCContentIdentifierInUPIDInfo.swift
//  
//
//  Created by Robert Galluccio on 31/03/2021.
//

public struct InvalidATSCContentIdentifierInUPIDInfo: Equatable {
    public let upidLength: Int
    public let staticBitsLength = 32
    public var calculatedContentIDBits: Int { (upidLength * 8) - staticBitsLength }
}
