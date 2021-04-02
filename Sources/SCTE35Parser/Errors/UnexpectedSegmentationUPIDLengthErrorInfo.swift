//
//  UnexpectedSegmentationUPIDLengthErrorInfo.swift
//  
//
//  Created by Robert Galluccio on 20/03/2021.
//

public struct UnexpectedSegmentationUPIDLengthErrorInfo: Equatable {
    /// This is the number of bytes that the UPID was expected to have as declared via
    /// `segmentation_upid_length`.
    public let declaredSegmentationUPIDLength: Int
    /// This is the number of bytes that the UPID was expected to have as defined by the
    /// specification for the given UPID type.
    public let expectedSegmentationUPIDLength: Int
    /// This is the type of the UPID that failed to parse properly.
    public let segmentationUPIDType: SegmentationDescriptor.SegmentationUPIDType
    
    public init(
        declaredSegmentationUPIDLength: Int,
        expectedSegmentationUPIDLength: Int,
        segmentationUPIDType: SegmentationDescriptor.SegmentationUPIDType
    ) {
        self.declaredSegmentationUPIDLength = declaredSegmentationUPIDLength
        self.expectedSegmentationUPIDLength = expectedSegmentationUPIDLength
        self.segmentationUPIDType = segmentationUPIDType
    }
}
