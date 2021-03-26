import XCTest
@testable import SCTE35Parser

final class SCTE35ParserTests: XCTestCase {
    func test_timeSignal() throws {
        let base64String = "/DA0AAAAAAAA///wBQb+cr0AUAAeAhxDVUVJSAAAjn/PAAGlmbAICAAAAAAsoKGKNAIAmsnRfg=="
        let hexString = "0xFC3034000000000000FFFFF00506FE72BD0050001E021C435545494800008E7FCF0001A599B00808000000002CA0A18A3402009AC9D17E"
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 1924989008))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 1207959694,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: SegmentationDescriptor.ScheduledEvent.DeliveryRestrictions(
                                webDeliveryAllowed: false,
                                noRegionalBlackout: true,
                                archiveAllowed: true,
                                deviceRestrictions: .none
                            ),
                            componentSegments: nil,
                            segmentationDuration: 27630000,
                            segmentationUPID: .ti("0x000000002CA0A18A"),
                            segmentationTypeID: .providerPlacementOpportunityStart,
                            segmentNum: 2,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0x9AC9D17E
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(hexString))
    }
    
    func test_spliceInsert() {
        let base64String = "/DAvAAAAAAAA///wFAVIAACPf+/+c2nALv4AUsz1AAAAAAAKAAhDVUVJAAABNWLbowo="
        let hexString = "0xFC302F000000000000FFFFF014054800008F7FEFFE7369C02EFE0052CCF500000000000A0008435545490000013562DBA30A"
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .spliceInsert(
                SpliceInsert(
                    eventId: 1207959695,
                    scheduledEvent: SpliceInsert.ScheduledEvent(
                        outOfNetworkIndicator: true,
                        isImmediateSplice: false,
                        spliceMode: .programSpliceMode(
                            SpliceInsert.ScheduledEvent.SpliceMode.ProgramMode(
                                spliceTime: SpliceTime(ptsTime: 1936310318)
                            )
                        ),
                        breakDuration: BreakDuration(
                            autoReturn: true,
                            duration: 5426421
                        ),
                        uniqueProgramId: 0,
                        availNum: 0,
                        availsExpected: 0
                    )
                )
            ),
            spliceDescriptors: [
                .availDescriptor(
                    AvailDescriptor(
                        identifier: 1129661769,
                        providerAvailId: 309
                    )
                )
            ],
            CRC_32: 0x62DBA30A
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(hexString))
    }
}
