//
//  Author.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 18/03/2022.
//

import Foundation

// MARK: - AuthorDetail
struct AuthorDetail: Codable {
    let name, username: String
    let avatarPath: String?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case name, username
        case avatarPath = "avatar_path"
        case rating
    }
}

extension AuthorDetail {
    static let mockedAuthorDetail1 = AuthorDetail(name: "John Doe", username: "johndoe123", avatarPath: "/uCmwgSbJAcHqNwSvQvTv2dB95tx.jpg", rating: 2)
    static let mockedAuthorDetail2 = AuthorDetail(name: "Stev Doe", username: "stev", avatarPath: "/utEXl2EDiXBK6f41wCLsvprvMg4.jpg", rating: nil)
}
