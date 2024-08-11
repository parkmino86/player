//
//  MigrationV4.swift
//  database
//
//  Created by minoh.park on 8/11/24.
//

import Foundation
import GRDB

struct MigrationV4: DatabaseMigrationProtocol {
    static let identifier = "v4"
    
    static func registerMigration(_ db: Database) throws {
        do {
            print("Starting migration v4: Renaming tables and updating foreign keys...")

            // 1. 기존 테이블의 이름을 변경
            try db.rename(table: "player", to: "playerDBModel")
            try db.rename(table: "team", to: "teamDBModel")
            
            // 2. 새로운 teamPlayerDBModel 테이블 생성
            try db.create(table: "teamPlayerDBModel") { t in
                t.column("id", .text).notNull().primaryKey().defaults(to: UUID().uuidString)
                t.column("teamId", .text).notNull().references("teamDBModel", onDelete: .cascade)
                t.column("playerId", .text).notNull().references("playerDBModel", onDelete: .cascade)
                
                // teamId와 playerId 조합에 대해 유니크 제약 조건 추가
                t.uniqueKey(["teamId", "playerId"])
            }
            
            // 3. 임시 테이블 temp_team_player 생성
            try db.create(table: "temp_team_player") { t in
                t.column("id", .text).notNull().primaryKey().defaults(to: UUID().uuidString)
                t.column("teamId", .text).notNull()
                t.column("playerId", .text).notNull()
            }
            
            // 4. 기존 team_player 테이블에서 데이터를 temp_team_player로 복사
            try db.execute(sql: """
                INSERT INTO temp_team_player (id, teamId, playerId)
                SELECT id, teamId, playerId FROM team_player
                """)
            
            // 5. 기존 team_player 테이블 삭제
            try db.drop(table: "team_player")
            
            // 6. 임시 테이블에서 teamPlayerDBModel 테이블로 데이터 복사
            try db.execute(sql: """
                INSERT INTO teamPlayerDBModel (id, teamId, playerId)
                SELECT id, teamId, playerId FROM temp_team_player
                """)
            
            // 7. 임시 테이블 temp_team_player 삭제
            try db.drop(table: "temp_team_player")

            print("Migration v4 completed successfully.")
        } catch {
            print("Migration v4 failed: \(error)")
            throw error  // 오류 발생 시 예외를 던져 마이그레이션 실패로 처리
        }
    }
}
