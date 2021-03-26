//
//  Data+hexString.swift
//  
//
//  Created by Robert Galluccio on 26/03/2021.
//

import Foundation

// https://stackoverflow.com/a/56870030/7039100

extension Data {
    init?(hexString: String) {
        let hexStr = hexString.dropFirst(hexString.hasPrefix("0x") ? 2 : 0)
        guard hexStr.count % 2 == 0 else { return nil }
        var newData = Data(capacity: hexStr.count / 2)
        var indexIsEven = true
        for i in hexStr.indices {
            if indexIsEven {
                let byteRange = i...hexStr.index(after: i)
                guard let byte = UInt8(hexStr[byteRange], radix: 16) else { return nil }
                newData.append(byte)
            }
            indexIsEven.toggle()
        }
        self = newData
    }
}
