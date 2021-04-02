//
//  InvalidBitStreamModeErrorInfo.swift
//  
//
//  Created by Robert Galluccio on 02/04/2021.
//

public struct InvalidBitStreamModeErrorInfo: Equatable {
    public let bsmod: Int
    public let acmod: Int?
    
    public init(bsmod: Int, acmod: Int?) {
        self.bsmod = bsmod
        self.acmod = acmod
    }
}
