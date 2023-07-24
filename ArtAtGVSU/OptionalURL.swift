//
//  URLOrNothing.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/15/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation

func optionalURL(_ string: String?) -> URL? {
    guard let string = string else { return nil }
    return URL(string: string)
}
