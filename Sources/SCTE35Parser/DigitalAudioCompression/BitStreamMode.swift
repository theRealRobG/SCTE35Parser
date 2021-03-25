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
}
