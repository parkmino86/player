//
//  TeamDBModel.swift
//  database
//
//  Created by minoh.park on 8/10/24.
//

import GRDB
import Foundation

public struct TeamDBModel: Codable, FetchableRecord, PersistableRecord, Identifiable, Hashable {
    public var id = UUID()
    public var name: String
        
    // 사용자 정의 생성자
    public init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}
