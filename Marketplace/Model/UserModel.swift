//
//  UserModel.swift
//  Marketplace
//
//  Created by Нуржан Орманали on 01.03.2021.
//

import Foundation

struct UserModel: Codable {
    let token: String
    let displayName: String
    let email: String
    let nicename: String
}

struct UserResponseModel: Codable {
    let data: UserModel?
}
