//
//  SpliceTime.swift
//  
//
//  Created by Robert Galluccio on 30/01/2021.
//

/// The `SpliceTime` structure, when modified by `ptsAdjustment`, specifies the time of the
/// splice event.
/**
 ```
 splice_time() {
   time_specified_flag             1 bslbf
   if(time_specified_flag == 1) {
     reserved                      6 bslbf
     pts_time                     33 uimsbf
   } else
     reserved                      7 bslbf
 }
 ```
 */
public struct SpliceTime: Equatable {
    /// A 33-bit field that indicates time in terms of ticks of the program's 90 kHz clock.
    /// This field, when modified by `ptsAdjustment`, represents the time of the intended
    /// splice point.
    public let ptsTime: UInt64?
    
    public init(ptsTime: UInt64?) {
        self.ptsTime = ptsTime
    }
}

// MARK: - Parsing

extension SpliceTime {
    init(bitReader: DataBitReader) throws {
        try bitReader.validate(
            expectedMinimumBitsLeft: 1,
            parseDescription: "SpliceTime; reading timeSpecifiedFlag"
        )
        let timeSpecifiedFlag = bitReader.bit() == 1
        if timeSpecifiedFlag {
            try bitReader.validate(
                expectedMinimumBitsLeft: 39,
                parseDescription: "SpliceTime; timeSpecifiedFlag == 1"
            )
            _ = bitReader.bits(count: 6)
            ptsTime = bitReader.uint64(fromBits: 33)
        } else {
            try bitReader.validate(
                expectedMinimumBitsLeft: 7,
                parseDescription: "SpliceTime; timeSpecifiedFlag == 0"
            )
            _ = bitReader.bits(count: 7)
            ptsTime = nil
        }
    }
}
