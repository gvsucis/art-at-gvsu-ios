//
//  DetailViewController.swift
//  ArtAtGVSU
//
//  Created by Kirthi Samson on 2/28/16.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import UIKit
import SwiftUI
import SDWebImage
import ImageViewer
import Combine

class ArtworkDetailController: UIViewController, ArtworkDetailDelegate, GalleryItemsDataSource {
    var artworkID: String? = nil
    private var viewModel: ArtworkDetailModel?
    private var favoriteSubscriber: AnyCancellable? = nil
    private var favoriteButton: UIBarButtonItem? = nil
    var hostingController: UIHostingController<ArtworkDetailView>? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ArtworkDetailModel(delegate: self, artworkID: artworkID!)
        hostingController = UIHostingController(rootView: ArtworkDetailView(viewModel: viewModel!))

        addChild(hostingController!)
        view.addSubview(hostingController!.view)
        hostingController!.didMove(toParent: self)

        viewModel!.fetchArtwork()
    }


    override func viewDidLayoutSubviews() {
        hostingController?.view.frame = self.view.frame
    }

    func presentArtworkDetail(artworkID: String) {
        let controller = ArtworkDetailController()
        controller.artworkID = artworkID
        navigationController!.pushViewController(controller, animated: true)
    }

    func presentImageViewer() {
        let controller = GalleryViewController(
            startIndex: viewModel!.index,
            itemsDataSource: self,
            configuration: GalleryConfiguration(
                [
                    .deleteButtonMode(.none),
                    .thumbnailsButtonMode(.none),
                    .videoAutoPlay(true)
                ]
            )
        )
        controller.footerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 10))
        controller.landedPageAtIndexCompletion = { self.viewModel?.index = $0 }
        presentImageGallery(controller)
    }

    @objc func shareArtworkLink() {
        present(UIActivityViewController(activityItems: ["Hello"], applicationActivities: nil), animated: true, completion: nil)
    }

    func itemCount() -> Int {
        return viewModel!.urlCount
    }

    func provideGalleryItem(_ index: Int) -> GalleryItem {
        let url = self.viewModel!.artwork!.mediaRepresentations[index]

        if url.hasVideoExtension {
            return GalleryItem.video(fetchPreviewImageBlock: { $0(UIImage()) }, videoURL: url)
        } else {
            return GalleryItem.image { callback in
                RemoteImage.fetch(url: url) { image in
                    callback(image)
                }
            }
        }
    }
}

struct ArtworkDetailRepresentable: UIViewControllerRepresentable {
    var artworkID: String?

    func makeUIViewController(context: Context) -> ArtworkDetailController {
        let controller = ArtworkDetailController()
        controller.artworkID = artworkID
        return controller
    }

    func updateUIViewController(_ uiViewController: ArtworkDetailController, context: Context) {
    }
}
