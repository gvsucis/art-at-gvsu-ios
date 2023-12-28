//
//  Loading.swift
//  ArtAtGVSU
//
//  Created by Andromeda on 11/9/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import Foundation
import SwiftUI

struct Dot: View {
    var isAnimated: Binding<Bool>
    var backgroundColors: [Color]
    var size: CGFloat? = 20
    var animationDelay: Double?
    
    var body: some View {
        Circle()
            .background(
                LinearGradient(gradient: Gradient(colors: backgroundColors),
                               startPoint: .leading, endPoint: .trailing)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            )
            .shadow(color: .purple.opacity(0.5), radius: 5, x: 1, y: 1)
            .foregroundColor(.clear)
            .frame(width: size, height: size)
            .scaleEffect(isAnimated.wrappedValue ? 1.0 : 0.5)
            .animation(.easeIn(duration: 1.0))
//            .animation(Animation.linear(duration: 0.5).repeatForever().delay(animationDelay ?? 0.0))
    }
}

struct AnimatedDotSequence: View {
    @State private var isAnimated = false
    var color1 = Color(red: 0.09, green: 0.14, blue: 0.14, opacity: 1)
    var color2 = Color(red: 0.27, green: 0.27, blue: 0.52, opacity: 1)
    var color11 = Color(red: 0.129, green: 0.137, blue: 0.349, opacity: 1)
    var color22 = Color(red: 0.05, green: 0.64, blue: 0.9, opacity: 1)

    var body: some View {
        HStack {
            Dot(isAnimated: $isAnimated, backgroundColors: [color1, color11], size: 12, animationDelay: 0.1)
            Dot(isAnimated: $isAnimated, backgroundColors: [color2, .purple], size: 16, animationDelay: 0.3)
            Dot(isAnimated: $isAnimated, backgroundColors: [color1, color11], size: 20, animationDelay: 0.4)
            Dot(isAnimated: $isAnimated, backgroundColors: [color2, .purple], size: 24, animationDelay: 0.6)
        }
        .onAppear{
            withAnimation {
                isAnimated = true
            }
        }
    }
}
