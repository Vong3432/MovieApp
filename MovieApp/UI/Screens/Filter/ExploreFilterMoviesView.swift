//
//  SearchMovieView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 02/06/2022.
//

import SwiftUI

struct ExploreFilterMoviesView: View {
    
    @EnvironmentObject private var appState: AppState
    @State private var expandRegion = false
    
    // Stores region and only update to binding after tapping "done"
    @State private var localSelectedRegion: Region.Result? = nil
    @Binding var selectedRegion: Region.Result
    
    let onDone: () -> ()?
    let regions: [Region.Result]
    
    init(regions: [Region.Result], selectedRegion: Binding<Region.Result>, onDone: @escaping () -> ()?) {
        self.regions = regions
        self.localSelectedRegion = selectedRegion.wrappedValue
        self.onDone = onDone
        self._selectedRegion = selectedRegion
    }
    
    private var regionGroupLabel: String {
        localSelectedRegion?.englishName ?? ""
    }
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        CloseFullScreenButton()
                        Text("filter")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button("done") {
                            // Update
                            if let localSelectedRegion = localSelectedRegion {
                                selectedRegion = localSelectedRegion
                            }
                            appState.closeSearchScreen()
                            onDone()
                        }.customTint(Color.theme.primary)
                    }
                    regionPicker
                }
            }
            .padding()
        }
        .preferredColorScheme(.dark)
    }
}

struct ExploreFilterMoviesView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreFilterMoviesView(
            regions: [],
            selectedRegion: .constant(.mockRegionResult),
            onDone: {})
            .preferredColorScheme(.dark)
    }
}

extension ExploreFilterMoviesView {
    private var regionPicker: some View {
        Section {
            DisclosureGroup(
                regionGroupLabel,
                isExpanded: $expandRegion) {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        ForEach(regions, id: \.id) { region in
                            Button {
                                localSelectedRegion = region
                                withAnimation(.spring()) {
                                    expandRegion = false
                                }
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(region.englishName)
                                        .font(.headline)
                                    Text(region.nativeName)
                                        .font(.subheadline)
                                        .opacity(0.6)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }.padding(.vertical)
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(12)
        } header: {
            Text("select_region")
                .padding(.top)
                .font(.headline)
        }
    }
}
