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
        Walkthrough(title: "walkthrough_feat1", description: "walkthrough_feat1_desc", imageName: "w1"),
        Walkthrough(title: "walkthrough_feat2", description: "walkthrough_feat2_desc", imageName: "w2"),
        Walkthrough(title: "walkthrough_feat3", description: "walkthrough_feat3_desc", imageName: "w3"),
    ]
}
