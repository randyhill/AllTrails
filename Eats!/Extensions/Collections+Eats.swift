//
//  Collections+Eats.swift
//  Eats!
//          Safe collections, don't let out of range indexes in Arrays and Collections crash and burn,
//          returning an optional allows your app to live on to continue to serve its user.
//          For more details read my highly rated post on StackOverflow (yes, shameless promotion)
//
// https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings/48103917#48103917
//
//  Created by Randy Hill on 8/21/21.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[ index] : nil
    }
    
    // Safely return subarray without crashing like Swift library slice function.
    // To do this we clip slice range to available array range.
    // If entire slice range is outside of array just return empty array.
    func clippedSlice(start: Int, end: Int) -> [Self.Element] {
        guard start < self.count, end >= 0 else {
            Log.error("Start: \(start), End: \(end) is not in array of size: \(self.count) range")
            return []
        }
        let startAt = start >= 0 ? start : 0
        let endAt = end < self.count ? end : self.count - 1
        let fullArray = Array(self)
        let slice = fullArray[startAt...endAt]
        return Array(slice)
    }
}

extension MutableCollection {
    subscript(safe index: Index) -> Element? {
        get {
            return indices.contains(index) ? self[ index] : nil
        }

        set(newValue) {
            if let newValue = newValue, indices.contains(index) {
                self[ index] = newValue
            }
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
