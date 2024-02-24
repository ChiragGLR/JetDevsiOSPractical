//
//  UserDefaultManager.swift
//  JetDevsHomeWork
//
//  Created by Chirag on 24/2/2024.
//

import Foundation

class UserDefaultManager {
    
    static let shared = UserDefaultManager()
    
    let userdefault = UserDefaults.standard
    
    // MARK: - Save
    func saveString(_ value: String, forKey key: String) {
        userdefault.set(value, forKey: key)
    }
    
    // MARK: - Get
    func getString(forKey key: String) -> String? {
        return userdefault.string(forKey: key)
    }
    
    // MARK: - Remove from local
    func removeObject(forKey key: String) {
        userdefault.removeObject(forKey: key)
    }
    
    // MARK: - Save And Fetch User
    func saveJson<T: Codable>(_ value: T, forKey key: String) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(value)
            userdefault.set(encodedData, forKey: key)
        } catch {
            debugPrint("Error saving data to UserDefaults: \(error)")
        }
    }
    
    func getJson<T: Codable>(forKey key: String) -> T? {
        if let savedData = UserDefaults.standard.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                let decodedValue = try decoder.decode(T.self, from: savedData)
                return decodedValue
            } catch {
                debugPrint("Error retrieving data from UserDefaults: \(error)")
            }
        }
        return nil
    }
}
