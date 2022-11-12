//
//  Phod.swift
//  Phod
//
//  Created by 鳥山彰仁 on 2022/11/12.
//


import Foundation

struct Phod: Codable {
    let id: Int
    let title: String
    let place: String
    let image: String
    let body: String
    let createdAt: String

    
    enum CodingKeys:  String, CodingKey {
        case id
        case title
        case place
        case image
        case body
        case createdAt = "created_at"
    }
}
