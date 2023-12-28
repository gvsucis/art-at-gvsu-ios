//
//  CloseButton.swift
//  ArtAtGVSU
//
//  Created by Andromeda on 11/9/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import Foundation
import SwiftUI

struct CloseButton: View {
    @State var tapped: Bool = false
    var action: DismissAction
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.black)
                .frame(width: 50, height: 50)
                .opacity(0.6)
                .shadow(color: .gray.opacity(0.5), radius: 4, x: 0, y: 4)
            Image(systemName: "xmark")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .light))
        }
        
        .scaleEffect(tapped ? 0.95 : 1)
        .onTapGesture {
            tapped = true
            self.action()
        }
        .padding(10)
    }
}
