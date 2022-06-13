//
//  StatsInfoView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 15/06/2022.
//

import SwiftUI

struct StatsInfoView: View {
    let icon: String
    let title: String
    let value: LocalizedStringKey
    let valueWithPlurals: Bool
    
    init(icon: String, title: String, value: LocalizedStringKey, valueWithPlurals: Bool? = false) {
        self.icon = icon
        self.title = title
        self.value = value
        self.valueWithPlurals = valueWithPlurals ?? false
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .font(.title)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(title))
                    .font(.caption)
                    .fontWeight(.bold)
                Text(value, tableName: valueWithPlurals ? "Plurals" : nil)
                    .font(.caption2)
                    .opacity(0.75)
                    .lineLimit(2)
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
}

struct StatsInfoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatsInfoView(
                icon: "dollarsign.circle.fill",
                title: "movie_stat_runtime_label",
                value: LocalizedStringKey("movie_stat_people_voted \(2)"))
                .frame(width: 200, alignment: .leading)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
                .previewDisplayName("eng")
                .environment(\.locale, .init(identifier: "en"))
            
            StatsInfoView(
                icon: "dollarsign.circle.fill",
                title: "movie_stat_runtime_label",
                value: LocalizedStringKey("movie_stat_runtime_minutes \(1)"),
                valueWithPlurals: true
            )
                .frame(width: 200, alignment: .leading)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
                .previewDisplayName("cn")
                .environment(\.locale, .init(identifier: "zh-Hans"))
        }
    }
}
