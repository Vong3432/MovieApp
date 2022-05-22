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
                List {
                    ForEach(vm.favoriteList) { favoritedMovie in
                        NavigationLink {
                            MovieDetailView(movie: favoritedMovie, authService: vm.authService, favoriteService: vm.dataService)
                        } label: {
                            MovieRowView(movie: favoritedMovie)
                                .padding(.vertical)
                        }
                    }
                    
                }
                .refreshable {
                    vm.loadFavorites()
                }
                .listStyle(.plain)
            }
        }
        .onAppear(perform: vm.loadFavorites)
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
