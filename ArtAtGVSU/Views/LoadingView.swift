//
//  LoadingView.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/23/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    @State var showProgress = false

    var body: some View {
        VStack {
            if showProgress {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear(perform: startDelayCountdown)
    }

    func startDelayCountdown() {
        if showProgress {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showProgress = true
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()

        LoadingView()
            .colorScheme(.dark)
    }
}
