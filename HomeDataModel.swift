//
//  HomeDataModel.swift
//  MyApp
//
//  Created by Admin on 28/2/2024.
//

import Foundation

struct HomeDataModel: Codable {
    let status, message: String
    let data: DataClass
}

struct DataClass: Codable {
    let available_dates: AvailableDates
    let product: [Product]
}

struct AvailableDates: Codable {
    let current_month_scrap_availability, next_month_scrap_availability: String
}

struct Product: Codable, Identifiable , Equatable{
    let id, name, price, type: String
    let image: String
}
