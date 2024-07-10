//
//  TourStopList.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 6/22/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import SwiftUI
import MapKit
import SDWebImageSwiftUI

struct TourDetailView: View {
    var tour: Tour
    @State var stops: [TourStop] = []
    @State var selected: TourAnnotation? = nil
    @State var annotations: [TourAnnotation] = []

    var body: some View {
        VStack(spacing: 0) {
            if (stops.isEmpty) {
                 LoadingView(showProgress: true)
            } else {
                TourMapView(pins: $annotations, selectedPin: $selected)
                ScrollViewReader { reader in
                    ScrollView(.horizontal) {
                        LazyHStack(alignment: .center) {
                            ForEach(stops) { stop in
                                SquareImage(
                                    url: stop.media,
                                    selected: stop.id == selected?.id
                                )
                                .onTapGesture {
                                    selected = annotations.first { $0.id == stop.id }
                                }
                            }
                        }
                        .frame(height: 144)
                        .padding(8)
                    }
                    .onChange(of: selected) {
                        if let stop = $0?.tourStop {
                            withAnimation {
                                reader.scrollTo(stop.id, anchor: .center)
                            }
                        }
                    }
                }
            }
        }
        .onAppear(perform: fetchStops)
    }

    func fetchStops() {
        if !annotations.isEmpty {
            return
        }

        tour.fetchTourStops { stops in
            DispatchQueue.main.async {
                self.stops = stops
                self.annotations = stops.map { TourAnnotation(tourStop: $0) }
            }
        }
    }
}

struct SquareImage: View {
    var url: URL?
    var selected: Bool = false

    var body: some View {
        GeometryReader { geo in
            WebImage(url: url)
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .cornerRadius(3)
                .clipped()
        }
        .aspectRatio(1, contentMode: .fill)
        .overlay {
            if selected {
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.blue, lineWidth: 6)
            }
        }
    }
}
