//
//  CountryPhoneData.swift
//  SwiftSearchableList
//
//  Created by Keita Nakashima on 2024/11/30.
//

import Foundation

struct CountryPhoneData: Codable, Identifiable {
    let id: String
    let name: String
    let name_ja: String
    let flag: String
    let code: String
    let dial_code: String
    let pattern: String
    let limit: Int
    
    static let allCountry: [CountryPhoneData] = Bundle.main.decode("CountryNumbers.json")
    static let example = allCountry[0]
}
