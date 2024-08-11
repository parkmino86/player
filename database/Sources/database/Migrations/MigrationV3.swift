//
//  MigrationV3.swift
//  database
//
//  Created by minoh.park on 8/11/24.
//

import Foundation
import GRDB

struct MigrationV3: DatabaseMigrationProtocol {
    static let identifier = "v3"
    
    static func registerMigration(_ db: Database) throws {
        do {
            print("Starting migration v3: Renaming 'score' column to 'backnumber' in 'player' table...")

            // 임시 테이블 생성
            try db.create(table: "new_player") { t in
                t.column("id", .text).notNull().primaryKey().defaults(to: UUID().uuidString)
                t.column("name", .text).notNull()
                t.column("backnumber", .integer).notNull() // 새로운 컬럼명
            }

            // 기존 데이터를 모두 읽어와 새로운 테이블로 복사
            try db.execute(sql: """
                INSERT INTO new_player (id, name, backnumber)
                SELECT id, name, score FROM player
                """)

            // 기존 테이블 삭제
            try db.drop(table: "player")

            // 새 테이블 이름 변경
            try db.rename(table: "new_player", to: "player")

            print("Migration v3 completed successfully.")
        } catch {
            print("Migration v3 failed: \(error)")
            throw error  // 오류 발생 시 예외를 던져 마이그레이션 실패로 처리
        }
    }
}
