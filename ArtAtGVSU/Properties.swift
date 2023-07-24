//
//  Properties.swift
//  ArtAtGVSU
//
//  Created by jocmp on 7/7/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//
//
import Foundation

//  This class MUST NOT contain cleartext secrets. Instead, place those secrets
//  inside the Secrets.plist file which is tracked outside version control.
class Properties: Codable {
    var art_gallery_base_url: String
    
    static let shared: Properties = {
        let secretsURL = Bundle.main.url(forResource: "Secrets", withExtension: "plist")!
        let data = try! Data(contentsOf: secretsURL)
        let decoder = PropertyListDecoder()
        
        let instance = try! decoder.decode(Properties.self, from: data)
        
        return instance
    }()
}
