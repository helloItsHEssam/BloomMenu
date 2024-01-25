//
//  ContentView.swift
//  BloomMenu
//
//  Created by HEssam Mahdiabadi on 1/25/24.
//

import SwiftUI

struct ContentView: View {
    
    private let colors: [Color] = [.blue, .red, .mint, .yellow, .green]
    private var baseAngle: Double
    
    @State private var isOpenMenu: Bool = false
    @State private var positionManager: PositionManager
    @State private var selectedColor: Color
    @State private var heightOfViewOnCloseState: CGFloat = 0.25
    @State private var degreeOfViewOnCloseState: CGFloat = 0.0
    @State private var offsetOfViewOnCloseState: CGFloat = 0.0
    @State private var heightOfCenterCircleState: CGFloat = 0.4
    
    init() {
        baseAngle = 360.0 / Double(colors.count)
        selectedColor = colors.last.unsafelyUnwrapped
        positionManager = PositionManager(itemsCount: colors.count)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [selectedColor, selectedColor.opacity(0.4)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .opacity(0.4)
                    .frame(width: isOpenMenu
                           ? geo.size.width * 0.18
                           : geo.size.width * heightOfCenterCircleState,
                           height: isOpenMenu
                           ? geo.size.width  * 0.18
                           : geo.size.width * heightOfCenterCircleState
                    )
                    .onChange(of: offsetOfViewOnCloseState) { newValue in
                        let height = min(0.4, ((0.18 * 0.3) / newValue))
                        withAnimation(Utility.centerCircleAnimation) {
                            heightOfCenterCircleState = height
                        }
                    }
                
                ForEach(Array(colors.enumerated()), id: \.offset) { index, color in
                    ItemView(isOpen: $isOpenMenu,
                             positionManager: $positionManager,
                             selectedColor: $selectedColor,
                             heightOnCloseState: $heightOfViewOnCloseState,
                             degreeOnCloseState: $degreeOfViewOnCloseState,
                             offsetOnCloseState: $offsetOfViewOnCloseState,
                             index: index,
                             parentWidth: geo.size.width,
                             baseAngle: baseAngle,
                             color: color
                    )
                }

            } // ZStack
            
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        } // geometry
    }
}
