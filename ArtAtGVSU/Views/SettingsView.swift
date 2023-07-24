//
//  SettingsView.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/30/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    init() {
        UITableView.appearance().backgroundColor = .clear
    }

    var body: some View {
        List {
            AboutSection()
            AppearanceSection()
            ExternalLinksSection()
            BuildSection()
        }
        .listStyle(GroupedListStyle())
        .background(Color.background)
    }
}

struct AppearanceSection: View {
    @AppStorage(APPEARANCE_KEY) var appearance: String = Appearance.dark.rawValue

    var body: some View {
        Section(header: Text("settings_AppearanceTitle")) {
            Picker(selection: $appearance, label: Text("settings_AppearanceTitle")) {
                Text("settings_AppearanceLight").tag(Appearance.LIGHT)
                Text("settings_AppearanceDark").tag(Appearance.DARK)
                Text("settings_AppearanceDefault").tag(Appearance.SYSTEM_DEFAULT)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct AboutSection: View {
    var body: some View {
        Section(header: Text("settings_AboutTitle")) {
            Text("settings_AboutDescription")
        }
    }
}

struct ExternalLinksSection: View {    var body: some View {
    Section {
        Link("settings_ArtGalleryLinkTitle", destination: URL(string: "https://www.gvsu.edu/artgallery/")!)
        Link("settings_MoreAppsByGVSULinkTitle", destination: URL(string: "https://itunes.apple.com/us/developer/grand-valley-state-university/id357181247")!)
        Link("settings_SchoolOfComputingLinkTitle", destination: URL(string: "http://aci.cis.gvsu.edu/")!)
    }
}
}

struct BuildSection: View {
    var body: some View {
        Section(header: Text("settings_BuildInformationTitle")) {
            Text(buildText)
        }
    }

    var buildText: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""

        return "\(version) (\(build))"
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
