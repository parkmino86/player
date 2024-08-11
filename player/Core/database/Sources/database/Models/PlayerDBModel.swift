//
//  PlayerDBModel.swift
//  database
//
//  Created by minoh.park on 8/10/24.
//

import GRDB
import Foundation

public struct PlayerDBModel: Codable, FetchableRecord, PersistableRecord, Identifiable {
    public var id = UUID()
    public var name: String
    public var backNumber: Int
    
    // 사용자 정의 생성자
    public init(id: UUID = UUID(), name: String, backNumber: Int) {
        self.id = id
        self.name = name
        self.backNumber = backNumber
    }
}
