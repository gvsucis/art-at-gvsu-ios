//
//  TabView.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/15/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI

let HOME_TAB = "home_tab"
let TOUR_TAB = "tour_tab"
let SEARCH_TAB = "search_tab"
let FAVORITES_TAB = "favorites_tab"

struct TabNavigationView: View {
    @State private var selection = HOME_TAB

    @State private var tabIDs = [
        HOME_TAB: UUID(),
        TOUR_TAB: UUID(),
        SEARCH_TAB: UUID(),
        FAVORITES_TAB: UUID()
    ]

    var selectionValue: Binding<String> {
        Binding(
            get: { selection },
            set: {
                if selection == $0 {
                    tabIDs[$0] = UUID()
                }
                selection = $0
            }
        )
    }

    var body: some View {
        TabView(selection: selectionValue) {
            NavigationView {
                HomeView()
                    .navigationBarTitle("navigation_Featured", displayMode: .large)
                    .toolbar {
                        NavigationLink(
                            destination: SettingsView()
                                .navigationBarTitle("navigation_Settings", displayMode: .inline),
                            label: { Image(systemName: "gearshape") }
                        )
                    }
                    .id(tabIDs[HOME_TAB])
            }
            .tabItem {
                Label("navigation_Browse", systemImage: "books.vertical.fill")
            }
            .tag(HOME_TAB)
            NavigationView {
                TourIndexView()
                    .navigationBarTitle("navigation_Tours", displayMode: .inline)
                    .id(tabIDs[TOUR_TAB])
            }
            .tabItem {
                Label("navigation_Tours", systemImage: "map.fill")
            }
            .tag(TOUR_TAB)
            NavigationView {
                SearchIndexView()
                    .navigationBarTitle("navigation_Search", displayMode: .inline)
                    .toolbar {
                        NavigationLink(destination: ScanQRCodeRepresentable()) {
                            Image(systemName: "qrcode.viewfinder")
                        }
                    }
            }
            .tabItem {
                Label("navigation_Search", systemImage: "magnifyingglass")
            }
            .id(tabIDs[SEARCH_TAB])
            .tag(SEARCH_TAB)
            NavigationView {
                FavoriteIndexRepresentable(id: tabIDs[FAVORITES_TAB])
                    .navigationBarTitle("navigation_Favorites", displayMode: .inline)
                    .toolbar {
                        Button(action: shareFavorites, label: { Image(systemName: "square.and.arrow.up") })
                    }
            }
            .tabItem {
                Label("navigation_Favorites", systemImage: "heart.fill")
            }
            .tag(FAVORITES_TAB)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .userColorTheme()
        .onAppear(perform: configureBarAppearances)
    }
}

func shareFavorites() {
    let activity = UIActivityViewController(
        activityItems: [exportFavorites()],
        applicationActivities: nil
    )
    if let root = UIApplication.shared.windows.first?.rootViewController{
        root.present(activity, animated: true, completion: nil)
    }
}

struct TabNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TabNavigationView()
            .colorScheme(.dark)
    }
}

func configureBarAppearances() {
    configureNavigationBarAppearance()
    configureUITabBarAppearance()
}

func configureNavigationBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(Color.background)
    if #available(iOS 15.0, *) {
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

func configureUITabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(Color.background)
    if #available(iOS 15.0, *) {
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
