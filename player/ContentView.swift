//
//  ContentView.swift
//  player
//
//  Created by minoh.park on 8/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PlayerListView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Players")
                }

            TeamListView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Teams")
                }
        }
    }
}
