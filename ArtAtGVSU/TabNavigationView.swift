//
//  TabView.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/15/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct TabNavigationView: View {
    @StateObject private var tabs = TabController()
    @State private var navPath = NavigationPath()

    @State private var tabIDs = buildTabIDs()
    var selectionValue: Binding<Tab> {
        Binding(
            get: { tabs.activeTab },
            set: {
                if tabs.activeTab == $0 {
                    tabIDs[$0] = UUID()
                }
                tabs.open($0)
            }
        )
    }

    var body: some View {
        TabView(selection: selectionValue) {
            NavigationStack {
                HomeView()
                    .navigationTitle("navigation_Featured")
                    .toolbarTitleDisplayMode(.large)
                    .toolbar {
                        NavigationLink(
                            destination: SettingsView()
                                .navigationBarTitle("navigation_Settings", displayMode: .inline)
                        ) {
                            Image(systemName: "gearshape")
                        }
                    }
            }
            .tabItem {
                Label("navigation_Browse", systemImage: "books.vertical.fill")
            }
            .tag(Tab.home)
            .id(tabIDs[Tab.home])

            NavigationStack {
                TourIndexView()
            }
            .tabItem {
                Label("navigation_Tours", systemImage: "map.fill")
            }
            .tag(Tab.tours)
            .id(tabIDs[Tab.tours])

            NavigationStack {
                SearchIndexView()
                    .navigationBarTitle("navigation_Search", displayMode: .inline)
                    .toolbar {
                        VisionCameraButton()
                        QRCodeReaderButton()
                    }
            }
            .tabItem {
                Label("navigation_Search", systemImage: "magnifyingglass")
            }
            .tag(Tab.search)
            .id(tabIDs[Tab.search])

            NavigationStack {
                FavoritesIndexView()
                    .navigationBarTitle("navigation_Favorites", displayMode: .inline)
                    .toolbar {
                        Button(action: shareFavorites) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
            }
            .tabItem {
                Label("navigation_Favorites", systemImage: "heart.fill")
            }
            .tag(Tab.favorites)
            .id(tabIDs[Tab.favorites])
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .userColorTheme()
        .onAppear(perform: configureBarAppearances)
        .environmentObject(tabs)
    }
}

func buildTabIDs() -> [Tab:UUID] {
    var tabIDs: [Tab:UUID] = [:]

    tabIDs.updateValue(UUID(), forKey: Tab.home)
    tabIDs.updateValue(UUID(), forKey: Tab.tours)
    tabIDs.updateValue(UUID(), forKey: Tab.search)
    tabIDs.updateValue(UUID(), forKey: Tab.favorites)

    return tabIDs
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
    if #unavailable(iOS 26.0) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.background)
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

func configureUITabBarAppearance() {
    if #unavailable(iOS 26.0) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.background)
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
