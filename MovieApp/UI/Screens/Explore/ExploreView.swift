//
//  ExploreView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 02/06/2022.
//

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var vm = ExploreViewModel(dataService: MovieDataService())
    @State private var showDetail = false
    @State private var selection: Movie? = nil
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            content
            
            if vm.movies.isEmpty && !vm.isLoading {
                Text("explore_no_result")
                    .opacity(0.75)
                    .multilineTextAlignment(.center)
            }
        }
        .background(
            NavigationLink(isActive: $showDetail, destination: {
                if let selection = selection {
                    MovieDetailView(movie: selection, authService: appState.authService, favoriteService: appState.favoriteService)
                }
            }, label: {
                EmptyView()
            }).isDetailLink(false)
        )
        .fullScreenCover(isPresented: $appState.showingSearchScreen) {
            ExploreFilterMoviesView(regions: vm.regions, selectedRegion: $vm.region) {
                vm.refresh()
            }
        }
        .toolbar {
            Button {
                Task {
                    await vm.loadRegions()
                    appState.showSearchScreen()
                }
            } label: {
                Image(systemName: "slider.vertical.3")
            }.padding(.leading)
        }
        .preferredColorScheme(.dark)
    }
    
    private func shouldFetchMore(_ movie: Movie) {
        Task {
            if movie == vm.movies.last {
                await vm.loadMore()
            }
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TabView {
                NavigationView {
                    ExploreView()
                        .navigationTitle("explore_tab_title")
                        .environmentObject(AppState())
                }.navigationViewStyle(.stack)
            }
            .previewDisplayName("ENG")
            .environment(\.locale, .init(identifier: "en"))
            
            TabView {
                NavigationView {
                    ExploreView()
                        .navigationTitle("explore_tab_title")
                        .environmentObject(AppState())
                }.navigationViewStyle(.stack)
            }
            .previewDisplayName("CN")
            .environment(\.locale, .init(identifier: "zh-Hans"))
        }
    }
}

extension ExploreView {
    private var content: some View {
        List {
            TextField("search_movie", text: $vm.searchText)
                .filledTextFieldStyle()
                .padding()
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.theme.background)
            
            Text("explore_result_label")
                .font(.callout)
                .fontWeight(.medium)
                .opacity(0.5)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.theme.background)
            
            movieList
                .listRowSeparator(.hidden)
                .listRowBackground(Color.theme.background)
        }
        .listStyle(.plain)
        .refreshable {
            vm.refresh()
        }
    }
    
    private var movieList: some View {
        Group {
            if vm.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach(0..<vm.movies.count, id: \.self) { idx in
                    Button {
                        selection = vm.movies[idx]
                        showDetail = true
                    } label: {
                        MovieRowView(idx: idx,movie: vm.movies[idx])
                            .padding(.bottom)
                            .padding(.bottom)
                            .onAppear {
                                shouldFetchMore(vm.movies[idx])
                            }
                    }
                    
                }
                
                if vm.isFetchingMore {
                    Text("loading")
                        .opacity(0.75)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}
