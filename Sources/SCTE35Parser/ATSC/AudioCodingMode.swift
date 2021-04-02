//
//  AudioCodingMode.swift
//  
//
//  Created by Robert Galluccio on 06/02/2021.
//

/// ATSC A/52 Table 5.8 Audio Coding Mode.
///
/// This 3-bit code, shown in Table 5.8, indicates which of the main service channels are in use, ranging
/// from 3/2 to 1/0. If the msb of acmod is a 1, surround channels are in use and surmixlev follows in
/// the bit stream. If the msb of acmod is a ‘0’, the surround channels are not in use and surmixlev does
/// not follow in the bit stream. If the lsb of acmod is a ‘0’, the center channel is not in use. If the
/// lsb of acmod is a ‘1’, the center channel is in use. Note: The state of acmod sets the number of
/// fullbandwidth channels parameter, nfchans, (e.g., for 3/2 mode, nfchans = 5; for 2/1 mode, nfchans =
/// 3; etc.). The total number of channels, nchans, is equal to nfchans if the lfe channel is off, and is
/// equal to 1 + nfchans if the lfe channel is on. If acmod is 0, then two completely independent program
/// channels (dual mono) are encoded into the bit stream, and are referenced as Ch1, Ch2. In this case, a
/// number of additional items are present in BSI or audblk to fully describe Ch2. Table 5.8 also
/// indicates the channel ordering (the order in which the channels are processed) for each of the modes.
/**
 ```
 acmod Audio Coding Mode nfchans Channel Array Ordering
 ‘000’ 1+1               2       Ch1, Ch2
 ‘001’ 1/0               1       C
 ‘010’ 2/0               2       L, R
 ‘011’ 3/0               3       L, C, R
 ‘100’ 2/1               3       L, R, S
 ‘101’ 3/1               4       L, C, R, S
 ‘110’ 2/2               4       L, R, SL, SR
 ‘111’ 3/2               5       L, C, R, SL, SR
 ```
 */
public enum AudioCodingMode: UInt8, Equatable {
    /**
     ```
     acmod Audio Coding Mode nfchans Channel Array Ordering
     ‘000’ 1+1               2       Ch1, Ch2
     ```
     */
    case oneAndOne
    /**
     ```
     acmod Audio Coding Mode nfchans Channel Array Ordering
     ‘001’ 1/0               1       C
     ```
     */
    case oneZero
    /**
     ```
     acmod Audio Coding Mode nfchans Channel Array Ordering
     ‘010’ 2/0               2       L, R
     ```
     */
    case twoZero
    /**
     ```
     acmod Audio Coding Mode nfchans Channel Array Ordering
     ‘011’ 3/0               3       L, C, R
     ```
     */
    case threeZero
    /**
     ```
     acmod Audio Coding Mode nfchans Channel Array Ordering
     ‘100’ 2/1               3       L, R, S
     ```
     */
    case twoOne
    /**
     ```
     acmod Audio Coding Mode nfchans Channel Array Ordering
     ‘101’ 3/1               4       L, C, R, S
     ```
     */
    case threeOne
    /**
     ```
     acmod Audio Coding Mode nfchans Channel Array Ordering
     ‘110’ 2/2               4       L, R, SL, SR
     ```
     */
    case twoTwo
    /**
     ```
     acmod Audio Coding Mode nfchans Channel Array Ordering
     ‘111’ 3/2               5       L, C, R, SL, SR
     ```
     */
    case threeTwo
}
