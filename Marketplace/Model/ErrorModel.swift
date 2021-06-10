//
//  ErrorModel.swift
//  Marketplace
//
//  Created by Нуржан Орманали on 01.03.2021.
//

import Foundation

struct ErrorModel: Error, Codable {
    let code: String
    let data: [ErrorData]
    let message: String
}

struct ErrorData: Codable {
    let status: Int
}
