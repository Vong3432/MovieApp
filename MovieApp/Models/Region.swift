//
//  Regions.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 02/06/2022.
//

/**
 URL:
 - https://api.themoviedb.org/3/watch/providers/regions?api_key=<<api_key>>&language=en-US
 
 JSON response:
 {
   "results": [
     {
       "iso_3166_1": "AR",
       "english_name": "Argentina",
       "native_name": "Argentina"
     },
     {
       "iso_3166_1": "AT",
       "english_name": "Austria",
       "native_name": "Austria"
     },
 
 */

import Foundation

struct Region: Codable {
    let results: [Result]
    
    struct Result: Codable, Identifiable, Equatable {
        
        static func ==(lhs: Region.Result, rhs: Region.Result) -> Bool {
            lhs.id == rhs.id
        }
        
        var id: String {
            iso31661
        }
        
        let iso31661, englishName, nativeName: String
    
        static let mockRegionResult = Result(iso31661: "US", englishName: "United States of America", nativeName: "United States")
    }
}
