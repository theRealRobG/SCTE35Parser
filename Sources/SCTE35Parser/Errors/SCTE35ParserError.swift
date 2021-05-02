//
//  SCTE35ParserError.swift
//  
//
//  Created by Robert Galluccio on 02/05/2021.
//

import Foundation

public struct SCTE35ParserError: Equatable, LocalizedError, CustomNSError {
    public static var errorDomain: String { ParserError.errorDomain }
    
    public let error: ParserError
    public let underlyingError: ParserError?
    
    public var errorCode: Int { error.errorCode }
    public var errorDescription: String? { error.errorDescription }
    public var failureReason: String? { error.failureReason }
    public var recoverySuggestion: String? { error.recoverySuggestion }
    public var helpAnchor: String? { error.helpAnchor }
    public var errorUserInfo: [String: Any] {
        var userInfo = error.errorUserInfo
        userInfo[NSUnderlyingErrorKey] = underlyingError
        return userInfo
    }
    
    public init(error: ParserError, underlyingError: ParserError? = nil) {
        self.error = error
        self.underlyingError = underlyingError
    }
}
