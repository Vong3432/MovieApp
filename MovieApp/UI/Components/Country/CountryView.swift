//
//  CountryView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 15/06/2022.
//

import SwiftUI

struct CountryView: View {
    let country: Movie.ProductionCountry
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(flag(country: country.wrappediso31661))
                .background(
                    Circle()
                        .fill(Color.theme.background)
                )
                .frame(width: 42, height: 42)
            
            VStack(alignment: .leading) {
                Text(country.wrappedName)
                    .font(.subheadline)
                Text(country.wrappediso31661)
                    .font(.caption)
                    .italic()
                    .opacity(0.65)
            }
            
            Spacer()
        }
    }
    
    private func flag(country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
}

struct CountryView_Previews: PreviewProvider {
    static var previews: some View {
        CountryView(country: Movie.fakedMovie2.productionCountries![0])
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
