import XCTest
@testable import SCTE35Parser

final class SCTE35ParserTests: XCTestCase {
    // MARK: - SCTE-35 2020 - 14. Sample SCTE 35 Messages (Informative)
    
    // 14.1. time_signal – Placement Opportunity Start
    func test_timeSignal_placementOpportunityStart() throws {
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
    
    // 14.2. splice_insert
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
    
    // 14.3. time_signal – Placement Opportunity End
    func test_timeSignal_placementOpportunityEnd() {
        let base64String = "/DAvAAAAAAAA///wBQb+dGKQoAAZAhdDVUVJSAAAjn+fCAgAAAAALKChijUCAKnMZ1g="
        let hexString = "0xFC302F000000000000FFFFF00506FE746290A000190217435545494800008E7F9F0808000000002CA0A18A350200A9CC6758"
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 1952616608))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 1207959694,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: SegmentationDescriptor.ScheduledEvent.DeliveryRestrictions(
                                webDeliveryAllowed: true,
                                noRegionalBlackout: true,
                                archiveAllowed: true,
                                deviceRestrictions: .none
                            ),
                            componentSegments: nil,
                            segmentationDuration: nil,
                            segmentationUPID: .ti("0x000000002CA0A18A"),
                            segmentationTypeID: .providerPlacementOpportunityEnd,
                            segmentNum: 2,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0xA9CC6758
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(hexString))
    }
    
    // 14.4. time_signal – Program Start/End
    func test_timeSignal_programStartEnd() {
        let base64String = "/DBIAAAAAAAA///wBQb+ek2ItgAyAhdDVUVJSAAAGH+fCAgAAAAALMvDRBEAAAIXQ1VFSUgAABl/nwgIAAAAACyk26AQAACZcuND"
        let hexString = "0xFC3048000000000000FFFFF00506FE7A4D88B60032021743554549480000187F9F0808000000002CCBC344110000021743554549480000197F9F0808000000002CA4DBA01000009972E343"
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 2051901622))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 1207959576,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: SegmentationDescriptor.ScheduledEvent.DeliveryRestrictions(
                                webDeliveryAllowed: true,
                                noRegionalBlackout: true,
                                archiveAllowed: true,
                                deviceRestrictions: .none
                            ),
                            componentSegments: nil,
                            segmentationDuration: nil,
                            segmentationUPID: .ti("0x000000002CCBC344"),
                            segmentationTypeID: .programEnd,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                ),
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 1207959577,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: SegmentationDescriptor.ScheduledEvent.DeliveryRestrictions(
                                webDeliveryAllowed: true,
                                noRegionalBlackout: true,
                                archiveAllowed: true,
                                deviceRestrictions: .none
                            ),
                            componentSegments: nil,
                            segmentationDuration: nil,
                            segmentationUPID: .ti("0x000000002CA4DBA0"),
                            segmentationTypeID: .programStart,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0x9972E343
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(hexString))
    }
    
    // 14.5. time_signal – Program Overlap Start
    func test_timeSignal_programOverlapStart() {
        let base64String = "/DAvAAAAAAAA///wBQb+rr//ZAAZAhdDVUVJSAAACH+fCAgAAAAALKVs9RcAAJUdsKg="
        let hexString = "0xFC302F000000000000FFFFF00506FEAEBFFF640019021743554549480000087F9F0808000000002CA56CF5170000951DB0A8"
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 2931818340))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 1207959560,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: SegmentationDescriptor.ScheduledEvent.DeliveryRestrictions(
                                webDeliveryAllowed: true,
                                noRegionalBlackout: true,
                                archiveAllowed: true,
                                deviceRestrictions: .none
                            ),
                            componentSegments: nil,
                            segmentationDuration: nil,
                            segmentationUPID: .ti("0x000000002CA56CF5"),
                            segmentationTypeID: .programOverlapStart,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0x951DB0A8
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(hexString))
    }
    
    // 14.6. time_signal – Program Blackout Override / Program End
    func test_timeSignal_programBlackoutoverrideProgramEnd() {
        let base64String = "/DBIAAAAAAAA///wBQb+ky44CwAyAhdDVUVJSAAACn+fCAgAAAAALKCh4xgAAAIXQ1VFSUgAAAl/nwgIAAAAACygoYoRAAC0IX6w"
        let hexString = "0xFC3048000000000000FFFFF00506FE932E380B00320217435545494800000A7F9F0808000000002CA0A1E3180000021743554549480000097F9F0808000000002CA0A18A110000B4217EB0"
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 2469279755))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 1207959562,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: SegmentationDescriptor.ScheduledEvent.DeliveryRestrictions(
                                webDeliveryAllowed: true,
                                noRegionalBlackout: true,
                                archiveAllowed: true,
                                deviceRestrictions: .none
                            ),
                            componentSegments: nil,
                            segmentationDuration: nil,
                            segmentationUPID: .ti("0x000000002CA0A1E3"),
                            segmentationTypeID: .programBlackoutOverride,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                ),
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 1207959561,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: SegmentationDescriptor.ScheduledEvent.DeliveryRestrictions(
                                webDeliveryAllowed: true,
                                noRegionalBlackout: true,
                                archiveAllowed: true,
                                deviceRestrictions: .none
                            ),
                            componentSegments: nil,
                            segmentationDuration: nil,
                            segmentationUPID: .ti("0x000000002CA0A18A"),
                            segmentationTypeID: .programEnd,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0xB4217EB0
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(hexString))
    }
    
    // 14.7. time_signal – Program End
    func test_timeSignal_programEnd() {
        let base64String = "/DAvAAAAAAAA///wBQb+rvF8TAAZAhdDVUVJSAAAB3+fCAgAAAAALKVslxEAAMSHai4="
        let hexString = "0xFC302F000000000000FFFFF00506FEAEF17C4C0019021743554549480000077F9F0808000000002CA56C97110000C4876A2E"
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 2935061580))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 1207959559,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: SegmentationDescriptor.ScheduledEvent.DeliveryRestrictions(
                                webDeliveryAllowed: true,
                                noRegionalBlackout: true,
                                archiveAllowed: true,
                                deviceRestrictions: .none
                            ),
                            componentSegments: nil,
                            segmentationDuration: nil,
                            segmentationUPID: .ti("0x000000002CA56C97"),
                            segmentationTypeID: .programEnd,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0xC4876A2E
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(hexString))
    }
    
    // 14.8. time_signal – Program Start/End - Placement Opportunity End
    func test_timeSignal_programStartEnd_placementOpportunityEnd() {
        let base64String = "/DBhAAAAAAAA///wBQb+qM1E7QBLAhdDVUVJSAAArX+fCAgAAAAALLLXnTUCAAIXQ1VFSUgAACZ/nwgIAAAAACyy150RAAACF0NVRUlIAAAnf58ICAAAAAAsstezEAAAihiGnw=="
        let hexString = "0xFC3061000000000000FFFFF00506FEA8CD44ED004B021743554549480000AD7F9F0808000000002CB2D79D350200021743554549480000267F9F0808000000002CB2D79D110000021743554549480000277F9F0808000000002CB2D7B31000008A18869F"
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 2832024813))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 1207959725,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: SegmentationDescriptor.ScheduledEvent.DeliveryRestrictions(
                                webDeliveryAllowed: true,
                                noRegionalBlackout: true,
                                archiveAllowed: true,
                                deviceRestrictions: .none
                            ),
                            componentSegments: nil,
                            segmentationDuration: nil,
                            segmentationUPID: .ti("0x000000002CB2D79D"),
                            segmentationTypeID: .providerPlacementOpportunityEnd,
                            segmentNum: 2,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                ),
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 1207959590,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: SegmentationDescriptor.ScheduledEvent.DeliveryRestrictions(
                                webDeliveryAllowed: true,
                                noRegionalBlackout: true,
                                archiveAllowed: true,
                                deviceRestrictions: .none
                            ),
                            componentSegments: nil,
                            segmentationDuration: nil,
                            segmentationUPID: .ti("0x000000002CB2D79D"),
                            segmentationTypeID: .programEnd,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                ),
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 1207959591,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: SegmentationDescriptor.ScheduledEvent.DeliveryRestrictions(
                                webDeliveryAllowed: true,
                                noRegionalBlackout: true,
                                archiveAllowed: true,
                                deviceRestrictions: .none
                            ),
                            componentSegments: nil,
                            segmentationDuration: nil,
                            segmentationUPID: .ti("0x000000002CB2D7B3"),
                            segmentationTypeID: .programStart,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0x8A18869F
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(hexString))
    }
    
    // MARK: - Examples from https://openidconnectweb.azurewebsites.net/Cue
    
    func test_timeSignal_segmentationDescriptor_adID() {
        let base64String = "/DA4AAAAAAAA///wBQb+AAAAAAAiAiBDVUVJAAAAA3//AAApPWwDDEFCQ0QwMTIzNDU2SBAAAGgCL9A="
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 0))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 3,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: nil,
                            componentSegments: nil,
                            segmentationDuration: 2702700,
                            segmentationUPID: .adID("ABCD0123456H"),
                            segmentationTypeID: .programStart,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0x68022FD0
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
    }
    
    func test_timeSignal_segmentationDescriptor_UMID() {
        let base64String = "/DBHAAAAAAAA///wBQb+AAAAAAAxAi9DVUVJAAAAA3+/BCAGCis0AQEBBQEBDSATAAAA0skDbI8ZU0OrcBTS1xi/2hEAAPUV9+0="
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 0))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 3,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: nil,
                            componentSegments: nil,
                            segmentationDuration: nil,
                            segmentationUPID: .umid("060A2B34.01010105.01010D20.13000000.D2C9036C.8F195343.AB7014D2.D718BFDA"),
                            segmentationTypeID: .programEnd,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0xF515F7ED
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
    }
    
    func test_timeSignal_segmentationDescriptor_ISAN_programStart() {
        let base64String = "/DA4AAAAAAAA///wBQb+AAAAAAAiAiBDVUVJAAAABn//AAApPWwGDAAAAAA6jQAAAAAAABAAAPaArb4="
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 0))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 6,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: nil,
                            componentSegments: nil,
                            segmentationDuration: 2702700,
                            segmentationUPID: .isan("0000-0000-3A8D-0000-Z-0000-0000-6"),
                            segmentationTypeID: .programStart,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0xF680ADBE
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
    }
    
    func test_timeSignal_segmentationDescriptor_ISAN_programEnd() {
        let base64String = "/DAzAAAAAAAA///wBQb+AAAAAAAdAhtDVUVJAAAABn+/BgwAAAAAOo0AAAAAAAARAAAT5alN"
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 0))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 6,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: nil,
                            componentSegments: nil,
                            segmentationDuration: nil,
                            segmentationUPID: .isan("0000-0000-3A8D-0000-Z-0000-0000-6"),
                            segmentationTypeID: .programEnd,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0x13E5A94D
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
    }
    
    func test_timeSignal_segmentationDescriptor_TID_programStart() {
        let base64String = "/DA4AAAAAAAA///wBQb+AAAAAAAiAiBDVUVJAAAAA3//AAApPWwHDE1WMDAwNDE0NjQwMBAAAIH4Mwc="
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 0))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 3,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: nil,
                            componentSegments: nil,
                            segmentationDuration: 2702700,
                            segmentationUPID: .tid("MV0004146400"),
                            segmentationTypeID: .programStart,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0x81F83307
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
    }
    
    func test_timeSignal_segmentationDescriptor_TID_programEnd() {
        let base64String = "/DAzAAAAAAAA///wBQb+AAAAAAAdAhtDVUVJAAAAA3+/BwxNVjAwMDQxNDY0MDARAAB2a6fC"
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 0))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 3,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: nil,
                            componentSegments: nil,
                            segmentationDuration: nil,
                            segmentationUPID: .tid("MV0004146400"),
                            segmentationTypeID: .programEnd,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0x766BA7C2
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
    }
    
    func test_timeSignal_segmentationDescriptor_ADI_ppoStart() {
        let base64String = "/DBLAAAAAAAA///wBQb+AAAAAAA1AjNDVUVJYgAFin//AABSZcAJH1NJR05BTDpEUjIxWjA3WlQ4YThhc25pdVVoZWlBPT00AADz3GdX"
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 0))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 1644168586,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: nil,
                            componentSegments: nil,
                            segmentationDuration: 5400000,
                            segmentationUPID: .adi("SIGNAL:DR21Z07ZT8a8asniuUheiA=="),
                            segmentationTypeID: .providerPlacementOpportunityStart,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0xF3DC6757
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
    }
    
    func test_timeSignal_segmentationDescriptor_ADI_ppoEnd() {
        let base64String = "/DBEAAAAAAAA///wBQb+AFJlwAAuAixDVUVJYgAFin+/CR1TSUdOQUw6My1zUTROZ0ZUME9qUHNHNFdxVVFvdzUAAEukzlg="
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 5400000))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 1644168586,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: nil,
                            componentSegments: nil,
                            segmentationDuration: nil,
                            segmentationUPID: .adi("SIGNAL:3-sQ4NgFT0OjPsG4WqUQow"),
                            segmentationTypeID: .providerPlacementOpportunityEnd,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0x4BA4CE58
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
    }
    
    func test_timeSignal_segmentationDescriptor_EIDR_programStart() {
        let base64String = "/DA4AAAAAAAA///wBQb+AAAAAAAiAiBDVUVJAAAAA3//AAApPWwKDBR4+FrhALBoW4+xyBAAAGij1lQ="
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 0))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 3,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: nil,
                            componentSegments: nil,
                            segmentationDuration: 2702700,
                            segmentationUPID: .eidr("10.5240/F85A-E100-B068-5B8F-B1C8-T"),
                            segmentationTypeID: .programStart,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0x68A3D654
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
    }
    
    func test_timeSignal_segmentationDescriptor_invalidEIDR() {
        let hexString = "0xFC30280000000000000000700506FF1252E9220012021043554549000000007F9F0A013050000015871049"
        XCTAssertThrowsError(try SpliceInfoSection(hexString)) { error in
            guard let error = error as? ParserError else { return XCTFail("Thrown error not ParserError") }
            switch error {
            case .unexpectedSegmentationUPIDLength(let info):
                XCTAssertEqual(1, info.declaredSegmentationUPIDLength)
                XCTAssertEqual(12, info.expectedSegmentationUPIDLength)
                XCTAssertEqual(.eidr, info.segmentationUPIDType)
            default:
                XCTFail("Unexpected ParserError")
            }
        }
    }
    
    func test_timeSignal_segmentationDescriptor_ATSC_content_identifier_programStart() {
        let base64String = "/DA4AAAAAAAA///wBQb+AAAAAAAiAiBDVUVJAAAAA3//AAApPWwLDADx7/9odW1hbjAxMhAAALdaWG4="
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 0))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 3,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: nil,
                            componentSegments: nil,
                            segmentationDuration: 2702700,
                            segmentationUPID: .atscContentIdentifier(
                                ATSCContentIdentifier(
                                    tsid: 241,
                                    endOfDay: 23,
                                    uniqueFor: 511,
                                    contentID: "human012"
                                )
                            ),
                            segmentationTypeID: .programStart,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0xB75A586E
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
    }
    
    func test_timeSignal_segmentationDescriptor_ATSC_content_identifier_programEnd() {
        let base64String = "/DAzAAAAAAAA///wBQb+AAAAAAAdAhtDVUVJAAAAA3+/CwwA8e//aHVtYW4wMTIRAABAycyr"
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 0))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 3,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: nil,
                            componentSegments: nil,
                            segmentationDuration: nil,
                            segmentationUPID: .atscContentIdentifier(
                                ATSCContentIdentifier(
                                    tsid: 241,
                                    endOfDay: 23,
                                    uniqueFor: 511,
                                    contentID: "human012"
                                )
                            ),
                            segmentationTypeID: .programEnd,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0x40C9CCAB
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
    }
    
    func test_timeSignal_segmentationDescriptor_TI_MPU() {
        let base64String = "/DB5AAAAAAAAAP/wBQb/DkfmpABjAhdDVUVJhPHPYH+/CAgAAAAABy4QajEBGAIcQ1VFSYTx71B//wAAK3NwCAgAAAAABy1cxzACGAIqQ1VFSYTx751/vwwbUlRMTjFIAQAAAAAxMzU2MTY2MjQ1NTUxQjEAAQAALL95dg=="
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 4534560420))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 2230439776,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: nil,
                            componentSegments: nil,
                            segmentationDuration: nil,
                            segmentationUPID: .ti("0x00000000072E106A"),
                            segmentationTypeID: .providerAdvertisementEnd,
                            segmentNum: 1,
                            segmentsExpected: 24,
                            subSegment: nil
                        )
                    )
                ),
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 2230447952,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: nil,
                            componentSegments: nil,
                            segmentationDuration: 2847600,
                            segmentationUPID: .ti("0x00000000072D5CC7"),
                            segmentationTypeID: .providerAdvertisementStart,
                            segmentNum: 2,
                            segmentsExpected: 24,
                            subSegment: nil
                        )
                    )
                ),
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 2230448029,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: nil,
                            componentSegments: nil,
                            segmentationDuration: nil,
                            segmentationUPID: .mpu(
                                SegmentationDescriptor.ManagedPrivateUPID(
                                    formatSpecifier: "RTLN",
                                    privateData: Data(base64Encoded: "MUgBAAAAADEzNTYxNjYyNDU1NTFCMQA=")!
                                )
                            ),
                            segmentationTypeID: .contentIdentification,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0x2CBF7976
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
    }
    
    func test_timeSignal_segmentationDescriptor_MID_ADS_TI() {
        let base64String = "/DA9AAAAAAAAAACABQb+0fha8wAnAiVDVUVJSAAAv3/PAAD4+mMNEQ4FTEEzMDkICAAAAAAuU4SBNAAAPIaCPw=="
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0x8,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 3522714355))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 1207959743,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: SegmentationDescriptor.ScheduledEvent.DeliveryRestrictions(
                                webDeliveryAllowed: false,
                                noRegionalBlackout: true,
                                archiveAllowed: true,
                                deviceRestrictions: .none
                            ),
                            componentSegments: nil,
                            segmentationDuration: 16317027,
                            segmentationUPID: .mid([.adsInformation("LA309"), .ti("0x000000002E538481")]),
                            segmentationTypeID: .providerPlacementOpportunityStart,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0x3C86823F
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
    }
    
    func test_timeSignal_segmentationDescriptor_ADS_programStart() {
        let base64String = "/DBZAAAAAAAA///wBQb+AAAAAABDAkFDVUVJAAAAC3//AAApMuAOLUFEUy1VUElEOmFhODViYmI2LTVjNDMtNGI2YS1iZWJiLWVlM2IxM2ViNzk5ORAAAJd2uP4="
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 0))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 11,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: nil,
                            componentSegments: nil,
                            segmentationDuration: 2700000,
                            segmentationUPID: .adsInformation("ADS-UPID:aa85bbb6-5c43-4b6a-bebb-ee3b13eb7999"),
                            segmentationTypeID: .programStart,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0x9776B8FE
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
    }
    
    func test_timeSignal_segmentationDescriptor_ADS_programEnd() {
        let base64String = "/DBUAAAAAAAA///wBQb+AAAAAAA+AjxDVUVJAAAAC3+/Di1BRFMtVVBJRDphYTg1YmJiNi01YzQzLTRiNmEtYmViYi1lZTNiMTNlYjc5OTkRAACV15uV"
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 0))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 11,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: nil,
                            componentSegments: nil,
                            segmentationDuration: nil,
                            segmentationUPID: .adsInformation("ADS-UPID:aa85bbb6-5c43-4b6a-bebb-ee3b13eb7999"),
                            segmentationTypeID: .programEnd,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0x95D79B95
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
    }
    
    func test_timeSignal_segmentationDescriptor_uri_programStart() {
        let base64String = "/DBZAAAAAAAA///wBQb+AAAAAABDAkFDVUVJAAAACn//AAApMuAPLXVybjp1dWlkOmFhODViYmI2LTVjNDMtNGI2YS1iZWJiLWVlM2IxM2ViNzk5ORAAAFz7UQA="
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 0))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 10,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: nil,
                            componentSegments: nil,
                            segmentationDuration: 2700000,
                            segmentationUPID: .uri(URL(string: "urn:uuid:aa85bbb6-5c43-4b6a-bebb-ee3b13eb7999")!),
                            segmentationTypeID: .programStart,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0x5CFB5100
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
    }
    
    func test_timeSignal_segmentationDescriptor_uri_programEnd() {
        let base64String = "/DBUAAAAAAAA///wBQb+AAAAAAA+AjxDVUVJAAAACn+/Dy11cm46dXVpZDphYTg1YmJiNi01YzQzLTRiNmEtYmViYi1lZTNiMTNlYjc5OTkRAAB2c6LA"
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .timeSignal(TimeSignal(spliceTime: SpliceTime(ptsTime: 0))),
            spliceDescriptors: [
                .segmentationDescriptor(
                    SegmentationDescriptor(
                        identifier: 1129661769,
                        eventId: 10,
                        scheduledEvent: SegmentationDescriptor.ScheduledEvent(
                            deliveryRestrictions: nil,
                            componentSegments: nil,
                            segmentationDuration: nil,
                            segmentationUPID: .uri(URL(string: "urn:uuid:aa85bbb6-5c43-4b6a-bebb-ee3b13eb7999")!),
                            segmentationTypeID: .programEnd,
                            segmentNum: 0,
                            segmentsExpected: 0,
                            subSegment: nil
                        )
                    )
                )
            ],
            CRC_32: 0x7673A2C0
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
    }
    
    func test_spliceInsert_availDescriptor_hex() {
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
                            SpliceInsert.ScheduledEvent.SpliceMode.ProgramMode(spliceTime: SpliceTime(ptsTime: 1936310318))
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
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(hexString))
    }
    
    func test_spliceInsert_availDescriptor_base64() {
        let base64String = "/DAvAAAAAAAAAP///wViAAWKf+//CXVCAv4AUmXAAzUAAAAKAAhDVUVJADgyMWLvc/g="
        let expectedSpliceInfoSection = SpliceInfoSection(
            tableID: 252,
            sapType: .unspecified,
            protocolVersion: 0,
            encryptedPacket: nil,
            ptsAdjustment: 0,
            tier: 0xFFF,
            spliceCommand: .spliceInsert(
                SpliceInsert(
                    eventId: 1644168586,
                    scheduledEvent: SpliceInsert.ScheduledEvent(
                        outOfNetworkIndicator: true,
                        isImmediateSplice: false,
                        spliceMode: .programSpliceMode(
                            SpliceInsert.ScheduledEvent.SpliceMode.ProgramMode(spliceTime: SpliceTime(ptsTime: 4453646850))
                        ),
                        breakDuration: BreakDuration(
                            autoReturn: true,
                            duration: 5400000
                        ),
                        uniqueProgramId: 821,
                        availNum: 0,
                        availsExpected: 0
                    )
                )
            ),
            spliceDescriptors: [
                .availDescriptor(
                    AvailDescriptor(
                        identifier: 1129661769,
                        providerAvailId: 3682865
                    )
                )
            ],
            CRC_32: 0x62EF73F8
        )
        try XCTAssertEqual(expectedSpliceInfoSection, SpliceInfoSection(base64String))
    }
}
