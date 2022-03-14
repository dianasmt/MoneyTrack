//
//  ExchangeRates.swift
//  MoneyTrack
//
//  Created by Диана Смахтина on 1.03.22.
//

import Foundation

struct ExchangeRates: Codable {
    let conversion_rates: [String: Double]
}
