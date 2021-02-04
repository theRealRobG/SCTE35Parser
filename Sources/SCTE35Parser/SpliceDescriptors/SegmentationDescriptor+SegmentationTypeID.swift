//
//  SegmentationDescriptor+SegmentationTypeID.swift
//  
//
//  Created by Robert Galluccio on 04/02/2021.
//

public extension SegmentationDescriptor {
    /// Designates the type of segmentation. All unused values are reserved. When the
    /// `SegmentationTypeID` is `0x01` (`contentIdentification`), the value of `SegmentationUPIDType`
    /// shall be non-zero. If `segmentationUPIDLength` is zero, then `SegmentationTypeID` shall be set to
    /// `0x00` for Not Indicated.
    enum SegmentationTypeID: UInt8 {
        case notIndicated = 0x00
        case contentIdentification = 0x01
        case programStart = 0x10
        case programEnd = 0x11
        case programEarlyTermination = 0x12
        case programBreakaway = 0x13
        case programResumption = 0x14
        case programRunoverPlanned = 0x15
        case programRunoverUnplanned = 0x16
        case programOverlapStart = 0x17
        case programBlackoutOverride = 0x18
        case programJoin = 0x19
        case chapterStart = 0x20
        case chapterEnd = 0x21
        case breakStart = 0x22
        case breakEnd = 0x23
        case openingCreditStart = 0x24
        case openingCreditEnd = 0x25
        case closingCreditStart = 0x26
        case closingCreditEnd = 0x27
        case providerAdvertisementStart = 0x30
        case providerAdvertisementEnd = 0x31
        case distributorAdvertisementStart = 0x32
        case distributorAdvertisementEnd = 0x33
        case providerPlacementOpportunityStart = 0x34
        case providerPlacementOpportunityEnd = 0x35
        case distributorPlacementOpportunityStart = 0x36
        case distributorPlacementOpportunityEnd = 0x37
        case providerOverlayPlacementOpportunityStart = 0x38
        case providerOverlayPlacementOpportunityEnd = 0x39
        case distributorOverlayPlacementOpportunityStart = 0x3A
        case distributorOverlayPlacementOpportunityEnd = 0x3B
        case providerPromoStart = 0x3C
        case providerPromoEnd = 0x3D
        case distributorPromoStart = 0x3E
        case distributorPromoEnd = 0x3F
        case unscheduledEventStart = 0x40
        case unscheduledEventEnd = 0x41
        case alternateContentOpportunityStart = 0x42
        case alternateContentOpportunityEnd = 0x43
        case providerAdBlockStart = 0x44
        case providerAdBlockEnd = 0x45
        case distributorAdBlockStart = 0x46
        case distributorAdBlockEnd = 0x47
        case networkStart = 0x50
        case networkEnd = 0x51
    }
}
