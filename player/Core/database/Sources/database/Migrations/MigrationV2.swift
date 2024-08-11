//
//  MigrationV2.swift
//  database
//
//  Created by minoh.park on 8/11/24.
//

import Foundation
import GRDB

struct MigrationV2: DatabaseMigrationProtocol {
    static let identifier = "v2"
    
    static func registerMigration(_ db: Database) throws {
        do {
            print("Starting migration v2: Adding team_player table and removing teamId from player table...")

            // 팀과 플레이어 간의 관계를 표현하는 중간 테이블 생성
            try db.create(table: "team_player", ifNotExists: true) { t in
                t.column("id", .text).notNull().primaryKey().defaults(to: UUID().uuidString)
                t.column("teamId", .text).notNull().references("team", onDelete: .cascade)
                t.column("playerId", .text).notNull().references("player", onDelete: .cascade)
            }

            // 기존 player 테이블에서 teamId 필드 제거
            try db.alter(table: "player") { t in
                t.drop(column: "teamId")
            }

            print("Migration v2 completed successfully.")
        } catch {
            print("Migration v2 failed: \(error)")
            throw error  // 오류 발생 시 예외를 던져 마이그레이션 실패로 처리
        }
    }
}
