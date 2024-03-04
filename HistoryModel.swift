//
//  HistoryModel.swift
//  MyApp
//
//  Created by Admin on 28/2/2024.
//

import Foundation


struct HistoryModel: Codable {
    let status: String
    let data: [HistoryDatum]
    let message: String
}

struct HistoryDatum: Codable, Hashable {
    let id, productName, date: String
    let fileName: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case productName = "product_name"
        case date
        case fileName = "file_name"
        case updatedAt = "updated_at"
    }
}
