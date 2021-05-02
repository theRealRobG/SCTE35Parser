//
//  SpliceCommand.swift
//  
//
//  Created by Robert Galluccio on 30/01/2021.
//

public enum SpliceCommand: Equatable {
    /// The `spliceNull` command is provided for extensibility of the standard. The `spliceNull` command
    /// allows a `SpliceInfoTable` to be sent that can carry descriptors without having to send one of
    /// the other defined commands. This command may also be used as a "heartbeat message" for monitoring
    /// cue injection equipment integrity and link integrity.
    case spliceNull
    /// The `SpliceSchedule` command is provided to allow a schedule of splice events to be conveyed
    /// in advance.
    case spliceSchedule(SpliceSchedule)
    /// The `spliceInsert` command shall be sent at least once for every splice event.
    case spliceInsert(SpliceInsert)
    /// The `timeSignal` provides a time synchronized data delivery mechanism. The syntax of the
    /// `timeSignal` allows for the synchronization of the information carried in this message with the
    /// system time clock (STC). The unique payload of the message is carried in the descriptor, however
    /// the syntax an transport capabilities afforded to `spliceInsert` messages are also afforded to the
    /// `timeSignal`. The carriage however can be in a different PID than that carrying the other cue
    /// messages used for signalling splice points.
    case timeSignal(TimeSignal)
    /// The `bandwidthReservation` command is provided for reserving bandwidth in a multiplex. A typical
    /// usage would be in a satellite delivery system that requires packets of a certain PID to always be
    /// present at the intended repetition rate to guarantee a certain bandwidth for that PID. This
    /// message differs from a `spliceNull` command so that it can easily be handled in a unique way by
    /// receiving equipment (i.e., removed from the multiplex by a satellite receiver). If a descriptor
    /// is sent with this command, it cannot be expected that it will be carried through the entire
    /// transmission chain and it should be a private descriptor that is utilized only by the bandwidth
    /// reservation process.
    case bandwidthReservation
    /// The `privateCommand` structure provides a means to distribute user-defined commands using the
    /// SCTE 35 protocol. The first bit field in each user-defined command is a 32-bit identifier, unique
    /// for each participating vendor. Receiving equipment should skip any `SpliceInfoSection` messages
    /// containing `privateCommand` structures with unknown identifiers.
    case privateCommand(PrivateCommand)
    
    public var type: SpliceCommandType {
        switch self {
        case .spliceNull: return .spliceNull
        case .spliceSchedule: return .spliceSchedule
        case .spliceInsert: return .spliceInsert
        case .timeSignal: return .timeSignal
        case .bandwidthReservation: return .bandwidthReservation
        case .privateCommand: return .privateCommand
        }
    }
}

// MARK: - Parsing

extension SpliceCommand {
    /// Constructs a `SpliceCommand` using a `DataBitReader` that should have been constructed with a
    /// SCTE35 `SpliceInfoSection`; the expectation is that the data has been read up until (but not
    /// including) the `spliceCommandType`.
    /// - Parameters:
    ///   - bitReader: A bit reader that is reading `Data` associated with a SCTE35 `SpliceInfoSection`
    ///   and has been advanced up until (not including) the `spliceCommandType`.
    ///   - spliceCommandLength: The indicated length in bytes of the `SpliceCommand` section (that
    ///   starts _after_ the `spliceCommandType`).
    /// - Throws: `ParserError`
    init(bitReader: DataBitReader, spliceCommandLength: Int) throws {
        let spliceCommandTypeRawValue = bitReader.byte()
        let bitsReadBeforeSpliceCommand = bitReader.bitsRead
        let expectedBitsReadAtEndOfSpliceCommand = bitReader.bitsRead + (spliceCommandLength * 8)
        guard let spliceCommandType = SpliceCommandType(rawValue: spliceCommandTypeRawValue) else {
            throw ParserError.unrecognisedSpliceCommandType(Int(spliceCommandTypeRawValue))
        }
        switch spliceCommandType {
        case .bandwidthReservation:
            self = .bandwidthReservation
        case .privateCommand:
            self = try .privateCommand(PrivateCommand(bitReader: bitReader, spliceCommandLength: spliceCommandLength))
        case .spliceInsert:
            self = .spliceInsert(try SpliceInsert(bitReader: bitReader))
        case .spliceNull:
            self = .spliceNull
        case .spliceSchedule:
            self = try .spliceSchedule(SpliceSchedule(bitReader: bitReader))
        case .timeSignal:
            self = .timeSignal(try TimeSignal(bitReader: bitReader))
        }
        if bitReader.bitsRead != expectedBitsReadAtEndOfSpliceCommand {
            bitReader.nonFatalErrors.append(
                .unexpectedSpliceCommandLength(
                    UnexpectedSpliceCommandLengthErrorInfo(
                        declaredSpliceCommandLengthInBits: spliceCommandLength * 8,
                        actualSpliceCommandLengthInBits: bitReader.bitsRead - bitsReadBeforeSpliceCommand,
                        spliceCommandType: spliceCommandType
                    )
                )
            )
        }
    }
}
