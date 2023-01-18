//
//  FloatingPanelFullLayout.swift
//  MazaadyTask
//
//  Created by iMokhles on 18/01/2023.
//

import Foundation
import FloatingPanel
import UIKit


class FloatingPanelStocksLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .full
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .full: FloatingPanelLayoutAnchor(absoluteInset: 60, edge: .top, referenceGuide: .safeArea),
    ]
}
