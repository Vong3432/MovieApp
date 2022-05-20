//
//  Walkthrough.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 17/05/2022.
//

import Foundation

struct Walkthrough: Identifiable {
    var id = UUID().uuidString
    let title: String
    let description: String
    let imageName: String
}

extension Walkthrough {
    static let walkthroughs = [
        Walkthrough(title: "Explore the latest movies", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", imageName: "w1"),
        Walkthrough(title: "Bookmark movies anytime", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ", imageName: "w2"),
        Walkthrough(title: "Enjoy online movie streaming services", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", imageName: "w3"),
    ]
}
