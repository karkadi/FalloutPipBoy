//
//  TimeRow.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 29/09/2025.
//
import SwiftUI

struct TimeRow: View {
    let title: String
    let time: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.custom("Digital-7Italic", size: 12))
                .foregroundColor(.yellow)
            
            Text(time)
                .font(.custom("Digital-7Italic", size: 12))
                .foregroundColor(.red)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background(Color.black)
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}
