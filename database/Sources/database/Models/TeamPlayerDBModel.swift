//
//  TeamPlayerDBModel.swift
//  database
//
//  Created by minoh.park on 8/10/24.
//

import GRDB
import Foundation

public struct TeamPlayerDBModel: Codable, FetchableRecord, PersistableRecord {
    public var id = UUID()
    public var teamId: UUID
    public var playerId: UUID
}
