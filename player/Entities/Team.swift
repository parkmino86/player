//
//  Team.swift
//  player
//
//  Created by minoh.park on 8/10/24.
//

import database
import Foundation

struct Team: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    
    init(dto: database.TeamDBModel) {
        self.id = dto.id
        self.name = dto.name
    }
    
    // 엔티티를 DBModel로 변환하는 메서드
    var toDBModel: TeamDBModel {
        return TeamDBModel(id: self.id, name: self.name)
    }
}
