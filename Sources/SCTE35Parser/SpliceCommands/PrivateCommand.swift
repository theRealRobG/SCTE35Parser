//
//  PrivateCommand.swift
//  
//
//  Created by Robert Galluccio on 30/01/2021.
//

/// The `PrivateCommand` structure provides a means to distribute user-defined commands using the SCTE 35
/// protocol. The first bit field in each user-defined command is a 32-bit identifier, unique for each
/// participating vendor. Receiving equipment should skip any `SpliceInfoSection` messages containing
/// `PrivateCommand` structures with unknown identifiers.
/**
 ```
 private_command() {
   identifier           32 uimsbf
   for(i=0; i<N; i++) {
     private_byte        8 uimsbf
   }
 }
 ```
 */
public struct PrivateCommand: Equatable {
    /// This 32-bit number is used to identify the owner of the command.
    ///
    /// The identifier is a 32-bit field as defined in [ITU-T H.222.0]. Refer to clauses 2.6.8 and 2.6.9
    /// of [ITU-T H.222.0] for descriptions of Registration descriptor and semantic definition of fields
    /// in registration descriptor. Only identifier values registered and recognized by SMPTE
    /// Registration Authority, LLC should be used (see [b-SMPTE RA]). Its use in the `PrivateCommand`
    /// structure shall scope and identify only the private information contained within this command.
    public let identifier: String
    /// The remainder of the descriptor is dedicated to data fields as required by the descriptor being
    /// defined.
    public let privateBytes: [UInt8]
    
    public init(
        identifier: String,
        privateBytes: [UInt8]
    ) {
        self.identifier = identifier
        self.privateBytes = privateBytes
    }
}

// MARK: - Parsing

extension PrivateCommand {
    init(bitReader: DataBitReader, spliceCommandLength: Int) throws {
        try bitReader.validate(
            expectedMinimumBitsLeft: spliceCommandLength * 8,
            parseDescription: "PrivateCommand; validating spliceCommandLength"
        )
        self.identifier = bitReader.string(fromBytes: 4)
        var bytesLeft = spliceCommandLength - 4
        var privateBytes = [UInt8]()
        while bytesLeft > 0 {
            bytesLeft -= 1
            privateBytes.append(bitReader.byte())
        }
        self.privateBytes = privateBytes
    }
}
