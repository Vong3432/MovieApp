//
//  Crew.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 18/03/2022.
//

/**
 API URL:
 - https://api.themoviedb.org/3/movie/{movie_id}/credits?api_key=<<api_key>>
 
 JSON Response:
 {
   "id": 550,
   "cast": [
     {
       "adult": false,
       "gender": 2,
       "id": 819,
       "known_for_department": "Acting",
       "name": "Edward Norton",
       "original_name": "Edward Norton",
       "popularity": 7.861,
       "profile_path": "/5XBzD5WuTyVQZeS4VI25z2moMeY.jpg",
       "cast_id": 4,
       "character": "The Narrator",
       "credit_id": "52fe4250c3a36847f80149f3",
       "order": 0
     },
     {
       "adult": false,
       "gender": 2,
       "id": 287,
       "known_for_department": "Acting",
       "name": "Brad Pitt",
       "original_name": "Brad Pitt",
       "popularity": 20.431,
       "profile_path": "/cckcYc2v0yh1tc9QjRelptcOBko.jpg",
       "cast_id": 5,
       "character": "Tyler Durden",
       "credit_id": "52fe4250c3a36847f80149f7",
       "order": 1
     },
    ...
]
 */
import Foundation

// MARK: - Crew
struct Crew: Codable, Identifiable {
    let id: Int
    let cast, crew: [Cast]?
}

// MARK: - Cast
struct Cast: Codable, Identifiable {
    let adult: Bool?
    let gender, id: Int?
    let knownForDepartment: Department?
    let name, originalName: String?
    let popularity: Double?
    let profilePath: String?
    let castID: Int?
    let character: String?
    let creditID: String?
    let order: Int?
    let department: Department?
    let job: String?

//    enum CodingKeys: String, CodingKey {
//        case adult, gender, id
//        case knownForDepartment = "known_for_department"
//        case name
//        case originalName = "original_name"
//        case popularity
//        case profilePath = "profile_path"
//        case castID = "cast_id"
//        case character
//        case creditID = "credit_id"
//        case order, department, job
//    }
    
    var wrappedOrder: Int {
        order ?? -1
    }
    
    var wrappedPopularity: Double {
        popularity ?? 0.0
    }
    
    var wrappedProfilePath: String {
        profilePath ?? "No profile found"
    }
    
    var wrappedName: String {
        name ?? "Unknown"
    }
    
    var wrappedOriName: String {
        originalName ?? "Unknown"
    }
    
    var wrappedCharacter: String {
        character ?? "Unknown"
    }
}

enum Department: String, Codable {
    case acting = "Acting"
    case art = "Art"
    case camera = "Camera"
    case costumeMakeUp = "Costume & Make-Up"
    case crew = "Crew"
    case directing = "Directing"
    case editing = "Editing"
    case lighting = "Lighting"
    case production = "Production"
    case sound = "Sound"
    case visualEffects = "Visual Effects"
    case writing = "Writing"
}

extension Crew {
    static let mockCrew = Crew(id: 550, cast: [.mockCast], crew: [.mockCast])
}

extension Cast {
    static let mockCast = Cast(adult: true, gender: 2, id: 819, knownForDepartment: .acting, name: "Edward", originalName: "Edw", popularity: 7.861, profilePath: "/5XBzD5WuTyVQZeS4VI25z2moMeY.jpg", castID: 4, character: "The Narrator", creditID: "52fe4250c3a36847f80149f3", order: 0, department: .acting, job: nil)
}
