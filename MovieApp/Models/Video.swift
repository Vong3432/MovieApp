//
//  Video.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 13/03/2022.
//

/**
 
 API URL:
 "https://api.themoviedb.org/3/movie/{movie_id}/videos?api_key=<<api_key>>&language=en-US"
 
 API Response:
 {
   "id": 550,
   "results": [
     {
       "iso_639_1": "en",
       "iso_3166_1": "US",
       "name": "Fight Club - Theatrical Trailer Remastered in HD",
       "key": "6JnN1DmbqoU",
       "site": "YouTube",
       "size": 1080,
       "type": "Trailer",
       "official": false,
       "published_at": "2015-02-26T03:19:25.000Z",
       "id": "5e382d1b4ca676001453826d"
     },
     {
       "iso_639_1": "en",
       "iso_3166_1": "US",
       "name": "Fight Club | #TBT Trailer | 20th Century FOX",
       "key": "BdJKm16Co6M",
       "site": "YouTube",
       "size": 1080,
       "type": "Trailer",
       "official": true,
       "published_at": "2014-10-02T19:20:22.000Z",
       "id": "5c9294240e0a267cd516835f"
     }
   ]
 }
 */

import Foundation

// MARK: - Video
struct Video: Codable, Identifiable {
    let iso639_1, iso3166_1, name, key: String?
    let site: String?
    let size: Int?
    let type: String?
    let official: Bool?
    let publishedAt, id: String?
    
    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
}

extension Video {
    static let mockedVideo = Video(iso639_1: "en", iso3166_1: "US", name: "Fight Club | #TBT Trailer | 20th Century FOX", key: "BdJKm16Co6M", site: "Youtube", size: 1080, type: "Trailer", official: true, publishedAt: "2014-10-02T19:20:22.000Z", id: "5c9294240e0a267cd516835f")
}
