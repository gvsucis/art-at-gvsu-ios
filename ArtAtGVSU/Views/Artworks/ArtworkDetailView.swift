//
//  ObjectDetailView.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 4/11/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI
import MapKit

struct ArtworkDetailView: View {
    @ObservedObject var viewModel: ArtworkDetailModel

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            ScrollView {
                if let artwork = viewModel.artwork {
                    TabView(selection: $viewModel.index) {
                        ForEach(orderedRepresentations(), id: \.url) { representation in
                            VStack {
                                if representation.url.hasVideoExtension {
                                    ArtworkDetailVideoPlaceholder(url: artwork.mediaSmall)
                                        .onTapGesture(perform: viewModel.delegate.presentImageViewer)
                                } else {
                                    ArtworkDetailTabImage(
                                        url: representation.url,
                                        onClick: viewModel.delegate.presentImageViewer
                                    )
                                }
                            }
                            .frame(height: 300)
                            .tag(representation.index)
                        }
                    }
                    .frame(height: 300)
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle())
                    ArtworkDetailContent(
                        artwork: artwork,
                        favorite: viewModel.favorite,
                        presentRelatedArtwork: viewModel.delegate.presentArtworkDetail
                    )
                } else {
                    VStack {
                        Rectangle()
                            .fill(Color(UIColor.systemGray2))
                            .frame(height: 300)
                            .aspectRatio(contentMode: .fill)

                        ProgressView()
                            .padding()

                        Spacer()
                    }
                }
            }
        }
        .background(Color.background)
    }

    func orderedRepresentations() -> [(index: Int, url: URL)] {
        guard let artwork = viewModel.artwork else { return [] }
        return artwork.mediaRepresentations.enumerated().map { index, url in (index: index, url: url) }
    }
}

struct ArtworkDetailContent: View {
    let artwork: Artwork
    @ObservedObject var favorite: FavoritesStore
    let presentRelatedArtwork: (_ artworkID: String) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            ArtworkDetailTitleRow(artwork: artwork, favorite: favorite)
            Divider().background(Color(UIColor.secondaryLabel))

            ForEach(nonEmptyTextRows(artwork), id: \.title ) { row in
                if row.isArtistName {
                    NavigationLink(destination: ArtistDetailView(id: artwork.artistID)) {
                        DetailTextRow(title: row.title, description: row.description)
                    }
                } else {
                    DetailTextRow(title: row.title, description: row.description)
                }
                Divider().background(Color(UIColor.secondaryLabel))
            }

            if let coordinate = artwork.locationGeoreference {
                MapSnapshot(coordinate: coordinate)
                    .frame(height: 200)
                    .cornerRadius(3.0)
                DetailDivider()
            }

            if !artwork.relatedWorks.isEmpty {
                ArtworkDetailRelatedWorks(
                    relatedWorks: artwork.relatedWorks,
                    presentArtwork: presentRelatedArtwork
                )
            }
        }
        .padding()
    }
}

private func nonEmptyTextRows(_ artwork: Artwork) -> [ArtworkDetailRow] {
    let rows: [ArtworkDetailRow] = [
        .artistName(RowValue(title: "artworkDetail_Artist", description: artwork.artistName)),
        .text(RowValue(title: "artworkDetail_WorkDescription", description: artwork.workDescription)),
        .text(RowValue(title: "artworkDetail_HistoricalContext", description: artwork.historicalContext)),
        .text(RowValue(title: "artworkDetail_WorkMedium", description: artwork.workMedium)),
        .text(RowValue(title: "artworkDetail_WorkDate", description: artwork.workDate)),
        .text(RowValue(title: "artworkDetail_Location", description: artwork.location)),
        .text(RowValue(title: "artworkDetail_Identifier", description: artwork.identifier)),
        .text(RowValue(title: "artworkDetail_CreditLine", description: artwork.creditLine))
    ]

    return rows.filter { !$0.description.isEmpty }
}

private struct RowValue {
    let title: String
    let description: String
}

private enum ArtworkDetailRow {
    case artistName(RowValue)
    case text(RowValue)

    var title: String {
        switch self {
        case .artistName(let value):
            return value.title
        case .text(let value):
            return value.title
        }
    }

    var description: String {
        switch self {
        case .artistName(let value):
            return value.description
        case .text(let value):
            return value.description
        }
    }

    var isArtistName: Bool {
        switch self {
        case .artistName:
            return true
        default:
            return false
        }
    }
}

struct TextOverlay: View {
    var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(
                colors: [Color.black.opacity(0.4), Color.black.opacity(0)]),
            startPoint: .bottom,
            endPoint: .center)
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle().fill(gradient)
        }
        .foregroundColor(.white)
    }
}

struct ArtworkDetail_Previews: PreviewProvider {
    static let relatedWorks = [
        Artwork(
            id: "3817",
            name: "Dutchman with Canal Boat",
            thumbnail: URL(string: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/5/6/2171_ca_object_representations_media_15698_small.jpg")
        ),
        Artwork(
            id: "3818",
            name: "Dutch Woodcutter",
            thumbnail: URL(string: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/7/3/56084_ca_object_representations_media_17364_small.jpg")
        )
    ]

    static let artwork = Artwork(
        id: "12853",
        mediaRepresentations: [
            "https:/artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/4/4/5337_ca_object_representations_media_14448_large.jpg"
        ].map { URL(string: $0)! },
        name: "Duo (Two)",
        artistName: "Judith Brown",
        historicalContext: "Judith Brown employed scrap metal in much of her work, ranging from small religious ceremonial objects such as a Hanukkah lamp in the collection of The Jewish Museum, to monumental sculptures and public art projects like the installation commissioned for the Federal Courthouse building in Trenton, New Jersey.",
        workDescription: "",
        workDate: "ca. 1985",
        workMedium: "Painted and welded scrap metal",
        location: "3rd Floor (JHZ)",
        identifier: "2013.68.7",
        creditLine: "A Gift of the Stuart and Barbara Padnos Foundation",
        locationGeoreference: CLLocationCoordinate2D(latitude: 42.962858349348, longitude: -85.886878535968),
        relatedWorks: relatedWorks,
        mediaMedium: URL(string: "https://artgallery.gvsu.edu//admin//media//collectiveaccess//images//1//4//4//96148_ca_object_representations_media_14448_icon.jpg")!
    )

    static var previews: some View {
        let viewModel = ArtworkDetailModel(delegate: Viewer(), artworkID: artwork.id)
        viewModel.artwork = artwork

        return Group {
            ArtworkDetailView(viewModel: viewModel)

            ArtworkDetailView(viewModel: ArtworkDetailModel(delegate: Viewer(), artworkID: artwork.id))
                .previewDisplayName("Loading Screen")

            ArtworkDetailView(viewModel: viewModel)
                .environment(\.sizeCategory, .extraExtraExtraLarge)
                .previewDevice("iPhone 8")
                .previewDisplayName("Extra Large Text")
        }
    }

    struct Viewer: ArtworkDetailDelegate {
        func presentImageViewer() {}
        func presentArtworkDetail(artworkID: String) {}
    }
}

