//
//  AddTeamPlayerView.swift
//  player
//
//  Created by minoh.park on 8/11/24.
//

import Foundation
import SwiftUI

struct AddTeamPlayerView: View {
    @StateObject private var viewModel: AddTeamPlayerViewModel
    @Environment(\.presentationMode) var presentationMode

    init(team: Team) {
        _viewModel = StateObject(wrappedValue: AddTeamPlayerViewModel(team: team))
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.players) { player in
                    HStack {
                        Text(player.name)
                        Spacer()
                        if player.isSelected {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.toggleSelection(for: player)
                    }
                }
            }
            .navigationTitle("Add/Remove Players")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if viewModel.saveChanges() {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear {
                viewModel.fetchPlayers()
                print("Players loaded: \(viewModel.players)")
            }
        }
    }
}
