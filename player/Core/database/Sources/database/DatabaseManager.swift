//
//  DatabaseManager.swift
//  database
//
//  Created by minoh.park on 8/10/24.
//

import GRDB
import Foundation

public class DatabaseManager {
    public static let shared = DatabaseManager()
    private var dbQueue: DatabaseQueue?

    private init() {
        setupDatabase()
    }

    // MARK: - Database Setup and Migration

    private func setupDatabase() {
        do {
            let databaseURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("players.sqlite")

            dbQueue = try DatabaseQueue(path: databaseURL.path)

            print("Checking if database migration is required...")
            if try needsMigration() {
                print("Starting migration...")
                try migrator.migrate(dbQueue!)
                print("Database migration completed successfully.")
            } else {
                print("No migration needed. Database is up to date.")
            }
            
        } catch {
            print("Database setup failed: \(error.localizedDescription)")
        }
    }

    private func needsMigration() throws -> Bool {
        guard let dbQueue = dbQueue else { throw DataBaseError.operation(.notInitialized) }
        return try dbQueue.read { db in
            return try !migrator.hasCompletedMigrations(db)
        }
    }

    // MARK: - Database Migrator

    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        // 자동으로 등록할 마이그레이션들
        let migrations: [DatabaseMigrationProtocol.Type] = [
            MigrationV1.self,   // v1: 초기 테이블 생성
            MigrationV2.self,   // v2: team_player 중간 테이블 추가 및 player 테이블에서 teamId 필드 제거
            MigrationV3.self,   // v3: player 테이블의 score 컬럼을 backnumber로 변경
            MigrationV4.self    // v4: 기존 테이블의 이름을 새 이름으로 변경
        ]

        // 각 마이그레이션을 자동으로 등록
        for migration in migrations {
            migrator.registerMigration(migration.identifier) { db in
                try migration.registerMigration(db)
            }
        }

        return migrator
    }
}

// MARK: - Team Management

extension DatabaseManager {
    public func fetchTeams() throws -> [TeamDBModel] {
        guard let dbQueue = dbQueue else { throw DataBaseError.operation(.notInitialized) }
        return try dbQueue.read { db in
            try TeamDBModel.fetchAll(db)
        }
    }

    public func addTeam(name: String) throws -> TeamDBModel {
        guard let dbQueue = dbQueue else { throw DataBaseError.operation(.notInitialized) }
        let team = TeamDBModel(name: name)
        try dbQueue.write { db in
            try team.insert(db)
        }
        return team
    }
    
    
    public func addPlayer(_ playerId: UUID, toTeam team: TeamDBModel) throws {
        guard let dbQueue = dbQueue else { throw DataBaseError.operation(.notInitialized) }

        try dbQueue.write { db in
            let teamPlayer = TeamPlayerDBModel(teamId: team.id, playerId: playerId)
            try teamPlayer.insert(db)
        }
    }
    
    public func removePlayer(_ playerId: UUID, fromTeam teamId: UUID) throws {
        guard let dbQueue = dbQueue else { throw DataBaseError.operation(.notInitialized) }
        try dbQueue.write { db in
            // 팀-선수 관계 삭제
            let teamPlayer = try TeamPlayerDBModel
                .filter(Column("teamId") == teamId && Column("playerId") == playerId)
                .fetchOne(db)
            
            if let teamPlayer = teamPlayer {
                try teamPlayer.delete(db)
                print("Player with ID \(playerId) removed from team with ID \(teamId) successfully.")
            } else {
                print("No matching team-player relationship found for deletion.")
                throw DataBaseError.feature(.relationshipNotFound)
            }
        }
    }

}

// MARK: - Player Management

extension DatabaseManager {
    public func fetchAllPlayers() throws -> [PlayerDBModel] {
        guard let dbQueue = dbQueue else { throw DataBaseError.operation(.notInitialized) }
        return try dbQueue.read { db in
            try PlayerDBModel.fetchAll(db)
        }
    }

    public func fetchPlayers(forTeam team: TeamDBModel) throws -> [PlayerDBModel] {
        guard let dbQueue = dbQueue else { throw DataBaseError.operation(.notInitialized) }

        return try dbQueue.read { db in
            let teamId = team.id
            let playerIds = try TeamPlayerDBModel
                .filter(Column("teamId") == teamId)
                .fetchAll(db)
                .map { $0.playerId }
            
            return try PlayerDBModel
                .filter(playerIds.contains(Column("id")))
                .fetchAll(db)
        }
    }

    public func addPlayer(name: String, backNumber: Int, toTeam team: TeamDBModel) throws {
        guard let dbQueue = dbQueue else { throw DataBaseError.operation(.notInitialized) }

        try dbQueue.write { db in
            let player = PlayerDBModel(name: name, backNumber: backNumber)
            try player.insert(db)
            
            let teamPlayer = TeamPlayerDBModel(teamId: team.id, playerId: player.id)
            try teamPlayer.insert(db)
        }
    }
    
    public func deletePlayer(withId id: UUID) throws {
        guard let dbQueue = dbQueue else { throw DataBaseError.operation(.notInitialized) }
        try dbQueue.write { db in
            guard let player = try PlayerDBModel.fetchOne(db, key: id) else {
                throw DataBaseError.feature(.playerNotFound)
            }
            try player.delete(db)
            print("Player with ID \(id) deleted successfully.")
        }
    }
}
