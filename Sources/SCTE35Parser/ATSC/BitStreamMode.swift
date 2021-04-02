//
//  BitStreamMode.swift
//  
//
//  Created by Robert Galluccio on 06/02/2021.
//

/// ATSC A/52 Table 5.7 Bit Stream Mode.
///
/// This 3-bit code indicates the type of service that the bit stream conveys.
/**
 ```
 bsmod acmod         Type of Service
 ‘000’ any           main audio service: complete main (CM)
 ‘001’ any           main audio service: music and effects (ME)
 ‘010’ any           associated service: visually impaired (VI)
 ‘011’ any           associated service: hearing impaired (HI)
 ‘100’ any           associated service: dialogue (D)
 ‘101’ any           associated service: commentary (C)
 ‘110’ any           associated service: emergency (E)
 ‘111’ ‘001’         associated service: voice over (VO)
 ‘111’ ‘010’ - ‘111’ main audio service: karaoke
 ```
 */
public enum BitStreamMode: Equatable {
    case completeMain
    case musicAndEffects
    case visuallyImpaired
    case hearingImpaired
    case dialogue
    case commentary
    case emergeny
    case voiceOver
    case karaoke
    
    public init?(bsmod: UInt8, acmod: UInt8?) {
        switch bsmod {
        case 0: self = .completeMain
        case 1: self = .musicAndEffects
        case 2: self = .visuallyImpaired
        case 3: self = .hearingImpaired
        case 4: self = .dialogue
        case 5: self = .commentary
        case 6: self = .emergeny
        case 7:
            guard let acmod = acmod else { return nil }
            if acmod == 1 {
                self = .voiceOver
            } else if acmod > 1, acmod < 8 {
                self = .karaoke
            } else {
                return nil
            }
        default:
            return nil
        }
    }
}
