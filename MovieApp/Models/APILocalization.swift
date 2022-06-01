//
//  APILocalization.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 01/06/2022.
//

import Foundation

extension String {
    func toMovieDBLocaleString() -> String {
        switch self {
        case "zh-Hans":
            return "zh-CN"
        default:
            return "en-US"
        }
    }
}
