//
//  LoginResponseModel.swift
//  JetDevsHomeWork
//
//  Created by Chirag on 23/2/2024.
//

import Foundation

// MARK: - CommonResponse
struct CommonResponse: Codable {
    let result: Bool?
    let errorMessage: String?
    let data: DataRes?

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case errorMessage = "error_message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let resultInt = try? values.decodeIfPresent(Int.self, forKey: .result) {
            // Convert integer value to boolean
            result = (resultInt != 0)
        } else {
            result = nil
        }
        errorMessage = try values.decodeIfPresent(String.self, forKey: .errorMessage)
        data = try values.decodeIfPresent(DataRes.self, forKey: .data)
    }
}

// MARK: - DataRes
struct DataRes: Codable {
    let user: User?
}

// MARK: - User
struct User: Codable {
    let userID: Int
    let userName: String
    let userProfileURL: String
    let createdAt: String

    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userName = "user_name"
        case userProfileURL = "user_profile_url"
        case createdAt = "created_at"
    }
}
