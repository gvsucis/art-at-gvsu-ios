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
                    .id(tabIDs[Tab.home])
            }
            .tabItem {
                Label("navigation_Browse", systemImage: "books.vertical.fill")
            }
            .tag(Tab.home)
            NavigationView {
                TourIndexView()
                    .navigationBarTitle("navigation_Tours", displayMode: .inline)
                    .id(tabIDs[Tab.tours])
            }
            .tabItem {
                Label("navigation_Tours", systemImage: "map.fill")
            }
            .tag(Tab.tours)
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
            .id(tabIDs[Tab.search])
            .tag(Tab.search)
            NavigationView {
                FavoritesIndexView()
                    .navigationBarTitle("navigation_Favorites", displayMode: .inline)
                    .toolbar {
                        Button(action: shareFavorites, label: { Image(systemName: "square.and.arrow.up") })
                    }
            }
            .tabItem {
                Label("navigation_Favorites", systemImage: "heart.fill")
            }
            .id(tabIDs[Tab.favorites])
            .tag(Tab.favorites)
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
    tabIDs.updateValue(UUID(), forKey: Tab.home)
    tabIDs.updateValue(UUID(), forKey: Tab.home)
    tabIDs.updateValue(UUID(), forKey: Tab.home)
    
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
