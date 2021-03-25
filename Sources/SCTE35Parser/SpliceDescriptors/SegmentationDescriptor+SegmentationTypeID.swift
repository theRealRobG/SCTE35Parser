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
        /// 0x00
        case notIndicated = 0x00
        /// 0x01
        case contentIdentification = 0x01
        /// 0x10
        case programStart = 0x10
        /// 0x11
        case programEnd = 0x11
        /// 0x12
        case programEarlyTermination = 0x12
        /// 0x13
        case programBreakaway = 0x13
        /// 0x14
        case programResumption = 0x14
        /// 0x15
        case programRunoverPlanned = 0x15
        /// 0x16
        case programRunoverUnplanned = 0x16
        /// 0x17
        case programOverlapStart = 0x17
        /// 0x18
        case programBlackoutOverride = 0x18
        /// 0x19
        case programJoin = 0x19
        /// 0x20
        case chapterStart = 0x20
        /// 0x21
        case chapterEnd = 0x21
        /// 0x22
        case breakStart = 0x22
        /// 0x23
        case breakEnd = 0x23
        /// 0x24
        case openingCreditStart = 0x24
        /// 0x25
        case openingCreditEnd = 0x25
        /// 0x26
        case closingCreditStart = 0x26
        /// 0x27
        case closingCreditEnd = 0x27
        /// 0x30
        case providerAdvertisementStart = 0x30
        /// 0x31
        case providerAdvertisementEnd = 0x31
        /// 0x32
        case distributorAdvertisementStart = 0x32
        /// 0x33
        case distributorAdvertisementEnd = 0x33
        /// 0x34
        case providerPlacementOpportunityStart = 0x34
        /// 0x35
        case providerPlacementOpportunityEnd = 0x35
        /// 0x36
        case distributorPlacementOpportunityStart = 0x36
        /// 0x37
        case distributorPlacementOpportunityEnd = 0x37
        /// 0x38
        case providerOverlayPlacementOpportunityStart = 0x38
        /// 0x39
        case providerOverlayPlacementOpportunityEnd = 0x39
        /// 0x3A
        case distributorOverlayPlacementOpportunityStart = 0x3A
        /// 0x3B
        case distributorOverlayPlacementOpportunityEnd = 0x3B
        /// 0x3C
        case providerPromoStart = 0x3C
        /// 0x3D
        case providerPromoEnd = 0x3D
        /// 0x3E
        case distributorPromoStart = 0x3E
        /// 0x3F
        case distributorPromoEnd = 0x3F
        /// 0x40
        case unscheduledEventStart = 0x40
        /// 0x41
        case unscheduledEventEnd = 0x41
        /// 0x42
        case alternateContentOpportunityStart = 0x42
        /// 0x43
        case alternateContentOpportunityEnd = 0x43
        /// 0x44
        case providerAdBlockStart = 0x44
        /// 0x45
        case providerAdBlockEnd = 0x45
        /// 0x46
        case distributorAdBlockStart = 0x46
        /// 0x47
        case distributorAdBlockEnd = 0x47
        /// 0x50
        case networkStart = 0x50
        /// 0x51
        case networkEnd = 0x51
    }
}
