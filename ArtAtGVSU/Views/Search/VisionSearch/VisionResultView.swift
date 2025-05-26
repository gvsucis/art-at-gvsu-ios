//
//  VisionResultView.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/26/25.
//  Copyright © 2025 Applied Computing Institute. All rights reserved.
//
import SwiftUI

struct VisionResultView: View {
    var capturedImage: UIImage? = nil
    @State var data: Async<[ImageResult]> = .uninitialized

    var body: some View {
        VStack {
            switch data {
            case .success(let results):
                VisionImageList(images: results)
            case .loading:
                LoadingView(showProgress: true)
            default:
                EmptyView()
            }
        }
        .onAppear(perform: search)
    }

    func search() {
        guard !data.isSuccess else { return }

        data = .loading

        Task {
            if let jpeg = capturedImage?.jpegData(compressionQuality: 0.5) {
                let result = await VisionSearchClient().search(image: jpeg)

                switch result {
                case .success(let response):
                    if let results = response?.results {
                        data = .success(results)
                    }
                case .failure:
                    data = .failure
                }
            }
        }
    }
}
