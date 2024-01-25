//
//  ItemView.swift
//  BloomMenu
//
//  Created by HEssam Mahdiabadi on 1/25/24.
//

import SwiftUI

struct Utility {
    
    static let animation = Animation.spring(response: 1.4, dampingFraction: 0.83, blendDuration: 0.5)
    static let centerCircleAnimation = Animation.spring(response: 0.5, dampingFraction: 0.83, blendDuration: 0.5)
}

struct ItemView: View {
    
    @Binding private var isOpen: Bool
    @Binding private var positionManager: PositionManager
    @Binding private var selectedColor: Color
    @Binding private var heightOfViewOnCloseState: CGFloat
    @Binding private var degreeOfViewOnCloseState: CGFloat
    @Binding private var offsetOfViewOnCloseState: CGFloat
    
    private var index: Int
    private var parentWidth: CGFloat
    private var baseAngle: Double
    private var color: Color
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { gesture in
                guard !isOpen else { return }
                let xTranslation = gesture.translation.width * (3 / 4)
                let yTranslation = gesture.translation.height
                
                if xTranslation >= 0 && yTranslation <= 0 {
                    withAnimation(Utility.animation) {
                        offsetOfViewOnCloseState = min(0.3, (0.3 * xTranslation) / 100)
                        degreeOfViewOnCloseState = min(baseAngle, (baseAngle * xTranslation) / 100)
                        heightOfViewOnCloseState = min(0.4, max(0.25, (0.4 * xTranslation) / 100))
                    }
                }
            }
            .onEnded { gesture in
                guard !isOpen else { return }
                
                withAnimation(Utility.animation) {
                    isOpen = offsetOfViewOnCloseState > 0.15 ? true : false
                    degreeOfViewOnCloseState = 0.0
                    offsetOfViewOnCloseState = 0.0
                    heightOfViewOnCloseState = 0.25
                }
            }
    }
    
    init(isOpen: Binding<Bool>,
         positionManager: Binding<PositionManager>,
         selectedColor: Binding<Color>,
         heightOnCloseState: Binding<CGFloat>,
         degreeOnCloseState: Binding<CGFloat>,
         offsetOnCloseState: Binding<CGFloat>,
         index: Int,
         parentWidth: CGFloat,
         baseAngle: Double,
         color: Color
    ) {
        self._isOpen = isOpen
        self._positionManager = positionManager
        self._selectedColor = selectedColor
        self._heightOfViewOnCloseState = heightOnCloseState
        self._degreeOfViewOnCloseState = degreeOnCloseState
        self._offsetOfViewOnCloseState = offsetOnCloseState
        self.index = index
        self.parentWidth = parentWidth
        self.baseAngle = baseAngle
        self.color = color
    }
    
    var body: some View {
        Capsule()
            .fill(color)
            .frame(
                width: parentWidth * 0.25,
                height: isOpen ? parentWidth  * 0.40 : parentWidth * heightOfViewOnCloseState
            )
            .offset(y: isOpen ? -parentWidth * 0.3 : -parentWidth * offsetOfViewOnCloseState)
            .rotationEffect(.degrees(
                isOpen ?
                positionManager[circlePositionAtIndex: index] * baseAngle
                : positionManager[circlePositionAtIndex: index] * degreeOfViewOnCloseState)
            )
            .onTapGesture {
                withAnimation(Utility.animation) {
                    isOpen.toggle()
                    positionManager.itemTapped(atIndex: index)
                    selectedColor = color
                }
            }
            .gesture(drag)
            .zIndex(positionManager[zIndexAtIndex: index])
    }
}
