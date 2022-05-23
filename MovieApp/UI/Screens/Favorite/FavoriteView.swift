//
//  FavoriteView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import SwiftUI

struct FavoriteView: View {
    @StateObject private var vm: FavoriteViewModel
    
    init(authService: MovieDBAuthProtocol, favoriteService: FavoritedDataServiceProtocol) {
        _vm = StateObject(wrappedValue: FavoriteViewModel(authService: authService, dataService: favoriteService))
    }
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            if vm.isLoading {
                ProgressView()
            } else {
                favoritedList
                if vm.favoriteList.isEmpty {
                    Text("You have not mark any movie/tv as favorite currently.")
                        .multilineTextAlignment(.center)
                }
            }
        }
        .onAppear {
            vm.clear()
            vm.loadFavorites()
        }
    }
    
    private func shouldFetchMore(_ favoritedMovie: Movie) {
        if favoritedMovie == vm.favoriteList.last {
            vm.loadMore()
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
        NavigationView {
            FavoriteView(
                authService: MovieDBAuthService(),
                favoriteService: FavoritedDataService()
            )
                .navigationTitle("Favorites")
        }.preferredColorScheme(.dark)
    }
}

extension FavoriteView {
    private var favoritedList: some View {
        List {
            ForEach(vm.favoriteList) { favoritedMovie in
                MovieRowView(
                    movie: favoritedMovie,
                    authService: vm.authService,
                    dataService: vm.dataService
                )
                    .padding(.vertical)
                    .onAppear {
                        shouldFetchMore(favoritedMovie)
                    }
            }
            .onDelete(perform: delete(for:))
            
            if vm.isFetchingMore {
                Text("Loading...")
                    .opacity(0.75)
                    .multilineTextAlignment(.center)
            }
        }
        .refreshable {
            vm.refresh()
        }
        .listStyle(.plain)
    }
}
