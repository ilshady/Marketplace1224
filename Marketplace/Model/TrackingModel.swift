//
//  TrackingModel.swift
//  Marketplace
//
//  Created by Ilshat Khairakhun on 03.05.2021.
//

import UIKit

struct TrackingModel: Codable {
    let metaData: [MetaData]
    let status: String
}

struct MetaData: Codable {
    let key: String
    let value: String
}
