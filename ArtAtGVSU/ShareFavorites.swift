//
//  BookmarkExport.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 8/9/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation

func exportFavorites(favorites: [Favorite] = FavoritesStore.favorites()) -> URL {
    let title = "Favorites \(Date().format(pattern: "yyyy-MM-dd HH:mm:ss"))"
    let destinationURL = URL(fileURLWithPath: NSTemporaryDirectory())

    let temporaryDirectoryURL =
        try! FileManager.default.url(for: .itemReplacementDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: destinationURL,
                                    create: true)

    let temporaryFilename = "\(String(title.replacingOccurrences(of: " ", with: "_"))).html"

    let temporaryFileURL =
        temporaryDirectoryURL.appendingPathComponent(temporaryFilename)

    FileManager.default.createFile(atPath: temporaryFileURL.path, contents: Data())

    let fileHandle = try! FileHandle(forWritingTo: temporaryFileURL)
    defer { fileHandle.closeFile() }

    fileHandle.write(utfString("<!doctype NETSCAPE-Bookmark-file-1>\n"))
    fileHandle.write(utfString("<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=UTF-8\">\n"))
    fileHandle.write(utfString("<h3>\(title)</h3>\n"))
    fileHandle.write(utfString("<dl>\n"))
    favorites.forEach { favorite in
        fileHandle.write(utfString("<dt><a href=\"\(Links.artworkDetail(id: favorite.artworkID))\">\(favorite.artworkName) - \(favorite.artistName)</a></dt>\n"))
    }
    fileHandle.write(utfString("</dl>"))

    return temporaryFileURL
}

private func utfString(_ value: String) -> Data {
    return value.data(using: .utf8)!
}

private extension Date {
    func format(pattern: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = pattern
        return formatter.string(from: self)
    }
}
