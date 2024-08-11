//
//  Player.swift
//  player
//
//  Created by minoh.park on 8/10/24.
//

import database
import Foundation

struct Player: Codable, Identifiable {
    var id = UUID()
    var name: String
    var backNumber: Int
    
    // DBModel을 엔티티로 초기화하는 생성자
    init(dto: PlayerDBModel) {
        self.id = dto.id
        self.name = dto.name
        self.backNumber = dto.backNumber
    }
    
    // 엔티티를 DBModel로 변환하는 메서드
    var toDBModel: PlayerDBModel {
        return PlayerDBModel(id: self.id, name: self.name, backNumber: self.backNumber)
    }
}
