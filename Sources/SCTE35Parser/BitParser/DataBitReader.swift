//
//  DataBitReader.swift
//  
//
//  Created by Robert Galluccio on 06/02/2021.
//

protocol DataBitReader: BitReader {
    /// A list of errors that have not caused the message to be un-parsable, but are inconsistent with the
    /// specification. An example of this could be a splice command who's computed length after parsing did
    /// not match the indicated length of the command.
    var nonFatalErrors: [ParserError] { get set }
    /// Validate that at least the expected minimum number of bits are left to read from the data.
    /// - Parameters:
    ///   - expectedMinimumBitsLeft: The minimum expected bits left to read from the data.
    ///   - parseDescription: A description of what was being attempted to be parsed that resulted in error.
    /// - Throws: `ParserError`
    func validate(expectedMinimumBitsLeft: Int, parseDescription: String) throws
}

extension DataBitReader {
    func validate(expectedMinimumBitsLeft: Int, parseDescription: String) throws {
        if bitsLeft < expectedMinimumBitsLeft {
            throw ParserError.unexpectedEndOfData(
                UnexpectedEndOfDataErrorInfo(
                    expectedMinimumBitsLeft: expectedMinimumBitsLeft,
                    actualBitsLeft: bitsLeft,
                    description: parseDescription
                )
            )
        }
    }
    
    func string(fromBytes bytes: UInt) -> String {
        return String(self.bytes(count: Int(bytes)).map { Character(UnicodeScalar($0)) })
    }
}
