import XCTest
@testable import SCTE35Parser

final class SCTE35ParserTests: XCTestCase {
    func testExample() throws {
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
}
