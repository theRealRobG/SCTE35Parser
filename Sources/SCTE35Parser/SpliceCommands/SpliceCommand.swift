//
//  SpliceCommand.swift
//  
//
//  Created by Robert Galluccio on 30/01/2021.
//

public enum SpliceCommand {
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
