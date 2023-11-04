//
//  ARArtworkButtonsView.swift
//  ArtAtGVSU
//
//  Created by Andromeda on 10/13/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import Foundation

import SwiftUI

struct ARArtworkButtonsView: View {
    
    var count: Count
    
    var body: some View {
        HStack(alignment: .center, spacing: 50) {
            
            Button { // Decrement Button //TODO: Scene light dec/inc
                count.num -= 1
                print("Tap -- : \(count.num)")
            } label: {
                Image(systemName: "minus.diamond")
            }

            Button { // Reset Button //TODO: Pause/resume
                count.num = 0
                print("Tap    : \(count.num)")
            } label: {
                // TODO: Change icon 
                Image(systemName: "xmark.diamond.fill")
            }
            
            Button { // Increment Button //TODO: Save current frame as screenshot
                count.num += 1
                print("Tap ++ : \(count.num)")
            } label: {
                Image(systemName: "plus.diamond")
            }
        }
        .padding(.bottom, 15)
        .font(.system(size: 32))
        .foregroundColor(.white)
        .frame(width: UIScreen.main.bounds.width, height: 80, alignment: .center)
        .background(Color.black)
        .opacity(0.87)
    }
}
