//
//  DataBaseError.swift
//  database
//
//  Created by minoh.park on 8/10/24.
//

import Foundation

enum DataBaseError: Error {
    // 데이터베이스 운영(Operation) 관련 오류
    case operation(DatabaseOperationError)
    
    // 피처 관련 오류
    case feature(FeatureError)
    
    // 데이터베이스 운영(Operation) 관련 오류 타입
    enum DatabaseOperationError: Error {
        case notInitialized
        case fetchFailed
        case insertFailed
    }
    
    // 피처 관련 오류 타입
    enum FeatureError: Error {
        case invalidTeamID
        case invalidPlayerID
        case playerNotFound
        case relationshipNotFound
    }
    
    // 오류 설명 추가
    var localizedDescription: String {
        switch self {
        case .operation(let dbError):
            switch dbError {
            case .notInitialized:
                return "The database has not been initialized."
            case .fetchFailed:
                return "Failed to fetch data from the database."
            case .insertFailed:
                return "Failed to insert data into the database."
            }
            
        case .feature(let featureError):
            switch featureError {
            case .invalidTeamID:
                return "The team ID provided is invalid."
            case .invalidPlayerID:
                return "The player ID provided is invalid."
            case .playerNotFound:
                return "The specified player was not found in the database."
            case .relationshipNotFound:
                return "The specified relationship between the team and the player was not found."
            }
        }
    }
}
