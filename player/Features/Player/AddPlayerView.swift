//
//  AddPlayerView.swift
//  player
//
//  Created by minoh.park on 8/10/24.
//

import SwiftUI

struct AddPlayerView: View {
    @ObservedObject var viewModel: PlayerViewModel

    @State private var playerName: String = ""
    @State private var playerBackNumber: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        Form {
            Section(header: Text("Select Team")) {
                Picker("Team", selection: $viewModel.selectedTeam) {
                    Text("Select").tag(nil as Team?)
                    ForEach(viewModel.teams, id: \.self) { team in
                        Text(team.name).tag(team as Team?)
                    }
                }
            }            
            Section(header: Text("Add Player")) {
                TextField("Player Name", text: $playerName)
                TextField("Back Number", text: $playerBackNumber)
                    .keyboardType(.numberPad)
                
                Button(action: {
                    viewModel.addPlayer(name: playerName, backNumber: playerBackNumber)
                    playerName = ""
                    playerBackNumber = ""
                    alertMessage = "Player added successfully!"
                    showAlert = true
                }) {
                    Text("Add Player")
                }
                .disabled(viewModel.selectedTeam == nil || playerName.isEmpty || playerBackNumber.isEmpty)
            }
        }
        .navigationTitle("Add Player")
        .onAppear {
            viewModel.fetchTeams()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}
