//
//  PlayerListView.swift
//  player
//
//  Created by minoh.park on 8/10/24.
//

import SwiftUI

struct PlayerListView: View {
    @StateObject private var viewModel = PlayerViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.players) { player in
                    VStack(alignment: .leading) {
                        Text(player.name)
                            .font(.headline)
                        Text("BackNumber: \(player.backNumber)")
                            .font(.subheadline)
                    }
                }
                .onDelete { offsets in
                    viewModel.deletePlayer(at: offsets)
                }
            }
            .navigationTitle("Players")
            .navigationBarItems(trailing: NavigationLink("Add", destination: AddPlayerView(viewModel: viewModel)))
            .onAppear {
                viewModel.fetchPlayers()
                print("Players loaded: \(viewModel.players)")
            }
        }
    }
}
