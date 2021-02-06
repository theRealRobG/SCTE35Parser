//
//  ParserError.swift
//  
//
//  Created by Robert Galluccio on 06/02/2021.
//

import Foundation

public enum ParserError: Error {
    case unexpectedEndOfData(UnexpectedEndOfDataErrorInfo)
    
    public var code: Code {
        switch self {
        case .unexpectedEndOfData: return .unexpectedEndOfData
        }
    }
}

extension ParserError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unexpectedEndOfData:
            return NSLocalizedString("Unexpected end of data during parsing.", comment: "")
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .unexpectedEndOfData(let info):
            return NSLocalizedString(
                "Expected at least \(info.expectedMinimumBitsLeft) bits left and instead was \(info.actualBitsLeft) when parsing: \(info.description).",
                comment: ""
            )
        }
    }
}

extension ParserError: CustomNSError {
    public static var errorDomain: String { "SCTE35ParserError" }
    
    public var errorCode: Int { code.rawValue }
    
    public var errorUserInfo: [String : Any] {
        switch self {
        case .unexpectedEndOfData(let info): return [Self.unexpectedEndOfDataUserInfoKey: info]
        }
    }
}
