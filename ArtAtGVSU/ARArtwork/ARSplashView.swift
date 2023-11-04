//
//  ARSplashView.swift
//  ArtAtGVSU
//
//  Created by Andromeda on 10/5/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import Foundation

import SwiftUI

import UIKit
import SceneKit
import ARKit


struct Circl: View {
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
            .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(animationDelay ?? 0.0))
    }
}

struct Anim: View {
    @State private var isAnimated = false
    var color1 = Color(red: 0.09, green: 0.14, blue: 0.14, opacity: 1)
    var color2 = Color(red: 0.27, green: 0.27, blue: 0.52, opacity: 1)
    var color11 = Color(red: 0.129, green: 0.137, blue: 0.349, opacity: 1)
    var color22 = Color(red: 0.05, green: 0.64, blue: 0.9, opacity: 1)
//    var color1 = Color(red: 0.09, green: 0.14, blue: 0.14, opacity: 1)
//    var color2 = Color(red: 0.027, green: 0.027, blue: 0.052, opacity: 1)
    var co3 = Color("#172554")
    
    var body: some View {
        HStack {
            Circl(isAnimated: $isAnimated, backgroundColors: [color1, color11], size: 15, animationDelay: 0.01)
            Circl(isAnimated: $isAnimated, backgroundColors: [color2, .purple], size: 24, animationDelay: 0.05)
            Circl(isAnimated: $isAnimated, backgroundColors: [color1, .purple], size: 30, animationDelay: 0.1)
            Circl(isAnimated: $isAnimated, backgroundColors: [color1, .purple], size: 24, animationDelay: 0.05)
            Circl(isAnimated: $isAnimated, backgroundColors: [color2, color11], size: 15, animationDelay: 0.01)
        }
        .onAppear{
            self.isAnimated = true
            
        }
    }
}

struct LoadingExperience: View {
    var body: some View {
        Text("Loading Experience...")
            
    }
}

struct closeButton: View {
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
           
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                   // your function
//
//                }
            
        }
        .padding(10)
    }
}


struct ARSplashView: View {
    @State var loading: Bool = false
    @State var arAssets: ARArtwork?
    var artwork: Artwork
//    @State var viewModel = ARArtworkContainerView.ViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var count = Count()
    
    var body: some View {
        ZStack {
            if !loading {
                VStack {
                    Text("Loading Experience")
                        .font(.title)
                    Anim()
                }
                .frame(alignment: .bottom)
            } else {
                ZStack {
//                    ARArtworkContainerView(viewModel: $viewModel, arAsset: $arAssets).ignoresSafeArea()
                    ARContainerView(sessionRunOptions:  [.removeExistingAnchors,
                             .resetTracking], artwork: artwork)
//                    Text(viewModel.trackingState?.description ?? "")
//                        .font(.headline)
//                        .foregroundColor(.green)
                    VStack {
                        Spacer()
                        ARArtworkButtonsView(count: count)
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
            HStack {
                closeButton(action: self.dismiss)
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .transition(.asymmetric(insertion: .scale, removal: .opacity))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .onAppear {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.loading = true
                }
            }
            fetchARResources()
        }
    }
    
    func fetchARResources() {
        print("Start fetching resources")
        Task {
            do {
                arAssets = try await ARArtwork.getARResources(artwork: artwork)
                    print("Successfully downloaded resources ", arAssets)
                    loading = false
            } catch {
                print("Error: \(error)")
            }
           
        }
    }
        
}


struct SplashView_Previews: PreviewProvider {
    static let artwork = Artwork(id: "17", name: "My Artwork")
    
    static var previews: some View {
        ARSplashView(arAssets: ARArtwork(id: "1", referenceImage: nil, video: nil, models: [], type: ""), artwork: artwork)
    }
}
