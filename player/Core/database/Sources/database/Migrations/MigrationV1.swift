//
//  MigrationV1.swift
//  database
//
//  Created by minoh.park on 8/11/24.
//

import Foundation
import GRDB

struct MigrationV1: DatabaseMigrationProtocol {
    static let identifier = "v1"
    
    static func registerMigration(_ db: Database) throws {
        do {
            print("Starting migration v1: Creating initial tables...")
            
            // team 테이블 생성
            try db.create(table: "team", ifNotExists: true) { t in
                t.column("id", .text).notNull().primaryKey().defaults(to: UUID().uuidString)
                t.column("name", .text).notNull().unique(onConflict: .ignore)
            }

            // player 테이블 생성
            try db.create(table: "player", ifNotExists: true) { t in
                t.column("id", .text).notNull().primaryKey().defaults(to: UUID().uuidString)
                t.column("name", .text).notNull()
                t.column("score", .integer).notNull() // 기존 컬럼
                t.column("teamId", .text).references("team", onDelete: .cascade)
            }

            print("Migration v1 completed successfully.")
        } catch {
            print("Migration v1 failed: \(error)")
            throw error  // 오류 발생 시 예외를 던져 마이그레이션 실패로 처리
        }
    }
}
