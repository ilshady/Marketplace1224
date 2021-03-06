//
//  ApiUrls.swift
//  Marketplace
//
//  Created by Нуржан Орманали on 01.03.2021.
//

import Foundation

struct APIUrls {
    static let baseUrl = "https://1224.kz/"
    static let apiVersion1 = "v1/"
    static let apiVersion3 = "v3/"
    static let loginModulePath = "jwt-auth/"
    static let jsonModule = "wp-json/"
    static let login = "token"
    static let orders = "orders"
    static let wc = "wc/"
    static let statusComplete = "?status=completed"
    
    static let generatedLoginUrl = baseUrl + jsonModule + loginModulePath + apiVersion1 + login
    static let generatedOrderUrl = baseUrl + jsonModule + wc + apiVersion3 + orders
}
