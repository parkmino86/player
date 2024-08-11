import SwiftUI

struct AddTeamView: View {
    @ObservedObject var addTeamViewModel: AddTeamViewModel

    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        Form {
            // 팀 추가 섹션
            Section(header: Text("Add Team")) {
                TextField("Team Name", text: $addTeamViewModel.newTeamName)                
                Button(action: {
                    // 팀 추가 로직
                    if addTeamViewModel.newTeamName.isEmpty {
                        alertMessage = "Team name cannot be empty."
                        showAlert = true
                    } else {
                        addTeamViewModel.addTeam()
                        alertMessage = "Team added successfully!"
                        showAlert = true
                    }
                }) {
                    Text("Add Team")
                }
                .disabled(addTeamViewModel.newTeamName.isEmpty)  // 팀 이름이 비어있으면 버튼 비활성화
            }
        }
        .navigationTitle("Add Team")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}
