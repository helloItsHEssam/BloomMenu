//
//  PositionManager.swift
//  BloomMenu
//
//  Created by HEssam Mahdiabadi on 1/25/24.
//

import Foundation

struct PositionManager {
    
    private var positions: [Int]
    private var topPositionValue: Int
    
    init(itemsCount: Int) {
        positions = [Int]()
        positions.reserveCapacity(itemsCount)
        
        for i in stride(from: 1, through: itemsCount, by: 1) {
            positions.append(i)
        }

        topPositionValue = positions.last.unsafelyUnwrapped
    }
    
    subscript(zIndexAtIndex index: Int) -> Double {
        Double(positions[index])
    }
    
    subscript(circlePositionAtIndex index: Int) -> Double {
        Double(positions.count - positions[index] + 1)
    }
    
    mutating func itemTapped(atIndex index: Int) {
        guard positions[index] != topPositionValue else { return }
        positions.reposition(basedOnSelectedIndex: index, maxValue: topPositionValue)
    }
}

fileprivate extension Array where Element == Int {
    
    mutating func reposition(basedOnSelectedIndex index: Int, maxValue max: Int) {
        let valueOnSelectedIndex = self[index]
        let diff = max - valueOnSelectedIndex
        
        var newPositionsHolder = [Int]()
        newPositionsHolder.reserveCapacity(count)
        
        for oldPosition in self {
            var newPosition = oldPosition + diff
            if newPosition > max {
                newPosition = newPosition - max
            }
            
            newPositionsHolder.append(newPosition)
        }
        
        self = newPositionsHolder
    }
}
