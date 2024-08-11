//
//  DatabaseMigrationProtocol.swift
//  database
//
//  Created by minoh.park on 8/11/24.
//

import Foundation
import GRDB

protocol DatabaseMigrationProtocol {
    static var identifier: String { get }
    static func registerMigration(_ db: Database) throws
}
