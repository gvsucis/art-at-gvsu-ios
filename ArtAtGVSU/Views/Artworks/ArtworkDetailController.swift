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

        navigationItem.largeTitleDisplayMode = .never

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

    static func present(artworkID: String, modal: Bool = false) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                  let keyWindow = windowScene.windows.first(where: \.isKeyWindow) else {
                return
            }

            let controller = ArtworkDetailController()
            controller.artworkID = artworkID

            if modal {
                let navController = UINavigationController(rootViewController: controller)
                keyWindow.rootViewController?.present(navController, animated: true)
            } else {
                if let navigationController = findNavigationController(from: keyWindow.rootViewController) {
                    navigationController.pushViewController(controller, animated: true)
                }
            }
        }
    }

    private static func findNavigationController(from viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else { return nil }

        if let navController = viewController as? UINavigationController {
            return navController
        }

        if let tabController = viewController as? UITabBarController,
           let selected = tabController.selectedViewController {
            return findNavigationController(from: selected)
        }

        if let presented = viewController.presentedViewController {
            return findNavigationController(from: presented)
        }

        for child in viewController.children {
            if let navController = findNavigationController(from: child) {
                return navController
            }
        }

        return viewController.navigationController
    }

    func presentImageViewer(url: URL) {
        let controller = GalleryViewController(
            startIndex: 0,
            itemsDataSource: MultimediaSource(url: url),
            configuration: GalleryConfiguration(
                [
                    .deleteButtonMode(.none),
                    .thumbnailsButtonMode(.none),
                    .videoAutoPlay(true)
                ]
            )
        )
        controller.footerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 10))
        presentImageGallery(controller)
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

        return galleryItem(url: url)
    }
}

func galleryItem(url: URL) -> GalleryItem {
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

class MultimediaSource: GalleryItemsDataSource {
    let url: URL

    init(url: URL) {
        self.url = url
    }

    func itemCount() -> Int {
        1
    }

    func provideGalleryItem(_ index: Int) -> ImageViewer.GalleryItem {
        return galleryItem(url: url)
    }
}
