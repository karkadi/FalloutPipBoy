//
//  TubePath.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 29/09/2025.
//
import SwiftUI

// MARK: - Auxiliary representations

/// A "tube" path between points with a slight rounding
struct TubePath: Shape {
    let from: CGPoint
    // swiftlint:disable:next identifier_name
    let to: CGPoint

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: from)
        path.addLine(to: to)
        return path
    }
}
