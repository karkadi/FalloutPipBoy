//
//  FalloutPipBoyApp.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 01/07/2025.
//

import SwiftUI

@main
struct FalloutPipBoyWatchApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .onAppear {
                    for family in UIFont.familyNames {
                        print("\(family)")
                        for name in UIFont.fontNames(forFamilyName: family) {
                            print("   \(name)")
                        }
                    }
                }
        }
    }
}
