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




struct LoadingExperience: View {
    var body: some View {
        Text("Loading Experience...")
            
    }
}




struct ARSplashView: View {
    @State var loading: Bool = false
    @State var arAssets: ARArtwork?
    var artwork: Artwork
    @State private var isARSessionRunning = true
//    @State var viewModel = ARArtworkContainerView.ViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var count = Count()
    
    var body: some View {
        ZStack {
            if !loading {
                VStack {
                    Text("Loading Experience")
                        .font(.title)
                    AnimatedDotSequence()
                }
                .frame(alignment: .bottom)
            } else {
                if arAssets != nil {
                    
                    ZStack {
                        ARContainerView(sessionRunOptions:  [.removeExistingAnchors,
                                                             .resetTracking], artwork: artwork, arArtwork: arAssets!)
                        VStack {
                            Spacer()
                            ARArtworkButtonsView(count: count)
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                }
            }
            HStack {
                CloseButton(action: self.dismiss)
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .transition(.asymmetric(insertion: .scale, removal: .opacity))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .onAppear {
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    print("View on appear Loading")
//                    self.loading = true
                }
//            }
            fetchARResources()
        }
        .onDisappear {
            self.loading = false
            print("View on disappear: ", self.loading)
    
            // Terminate AR session when the view disappears
                  
        }
    }
    
    func fetchARResources() {
        print("Start fetching resources")
        Task {
            //TODO: use observer pattern
            do {
                arAssets = try await ARArtwork.getARResources(artwork: artwork)
                    print("Successfully downloaded resources ")
                    loading = true
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
