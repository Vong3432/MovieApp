//
//  FavoriteView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import SwiftUI

struct FavoriteView: View {
    @Environment(\.editMode) var mode
    @StateObject private var vm: FavoriteViewModel
    
    init(authService: MovieDBAuthProtocol, favoriteService: FavoritedDataServiceProtocol) {
        _vm = StateObject(wrappedValue: FavoriteViewModel(authService: authService, dataService: favoriteService))
    }
    @State private var showDetail = false
    @State private var selection: Movie? = nil
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            if vm.isLoading {
                ProgressView()
            } else {
                favoritedList
                if vm.favoriteList.isEmpty {
                    Text("favorite_no_result")
                        .multilineTextAlignment(.center)
                }
            }
        }
        .background(
            NavigationLink(isActive: $showDetail, destination: {
                if let selection = selection {
                    MovieDetailView(movie: selection, authService: vm.authService, favoriteService: vm.dataService)
                }
            }, label: {
                EmptyView()
            }).isDetailLink(false)
        )
        .task {
            vm.clear()
            try? await Task.sleep(nanoseconds: 1_000_000)
            await vm.loadFavorites()
        }
    }
    
    private func shouldFetchMore(_ favoritedMovie: Movie) async {
        if favoritedMovie == vm.favoriteList.last {
            await vm.loadMore()
        }
    }
    
    private func delete(for index: IndexSet) {
        guard let idx = index.first else { return }
        let movie = vm.favoriteList[idx]
        vm.favoriteList.remove(atOffsets: index)
        
        vm.remove(movie)
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                FavoriteView(
                    authService: MovieDBAuthService(),
                    favoriteService: FavoritedDataService()
                )
                    .navigationTitle("favorite_tab_title")
            }
            .environment(\.locale, .init(identifier: "en"))
            .preferredColorScheme(.dark)
            
            NavigationView {
                FavoriteView(
                    authService: MovieDBAuthService(),
                    favoriteService: FavoritedDataService()
                )
                    .navigationTitle("favorite_tab_title")
            }
            .environment(\.locale, .init(identifier: "zh-Hans"))
            .preferredColorScheme(.dark)
        }
    }
}

extension FavoriteView {
    private var favoritedList: some View {
        List {
            ForEach(vm.favoriteList) { favoritedMovie in
                Button {
                    selection = favoritedMovie
                    showDetail = true
                } label: {
                    FavoriteMovieRowView(movie: favoritedMovie)
                        .padding(.vertical)
                        .onAppear {
                            Task {
                                await shouldFetchMore(favoritedMovie)
                            }
                        }
                }
                
            }
            .onDelete(perform: delete(for:))
            if vm.isFetchingMore {
                Text("loading")
                    .opacity(0.75)
                    .multilineTextAlignment(.center)
            }
        }
        .accessibilityIdentifier("FavoriteList")
        .refreshable {
            Task {
                await vm.refresh()
            }
        }
        .listStyle(.plain)
    }
}
