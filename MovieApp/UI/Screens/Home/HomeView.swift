//
//  HomeView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var vm = HomeViewModel(dataService: MovieDataService())
    @State private var size: CGSize = .zero
    @State private var currentPage = 0
    @State private var showDetail = false
    @State private var selectedMovie: Movie? = nil
    
    init() {
        UITableView.appearance().backgroundColor = UIColor(Color.theme.background)
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                initial
                    .onAppear {
                        size = geo.size
                    }
                    .background(
                        NavigationLink(isActive: $showDetail, destination: {
                            if let selectedMovie = selectedMovie {
                                MovieDetailView(
                                    movie: selectedMovie,
                                    authService: appState.authService,
                                    favoriteService: appState.favoriteService
                                )
                            }
                        }, label: {
                            EmptyView()
                        }).isDetailLink(false)
                    )
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            NavigationView {
                HomeView()
                    .environmentObject(AppState())
                    .navigationTitle("home_tab_title")
            }
            .navigationViewStyle(.stack)
        }.preferredColorScheme(.dark)
    }
}

extension HomeView {
    
    private var initial: some View {
        VStack {
            if vm.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .accessibilityIdentifier("HomeProgressView")
            } else {
                List {
                    topRatedMoviesList
                    upcomingMoviesList
                }
                .accessibilityIdentifier("HomeList")
                .listStyle(.sidebar)
                .refreshable {
                    vm.loadData()
                }
            }
        }
    }
    
    private var topRatedMoviesList: some View {
        VStack(alignment: .leading) {
            Text("top_rated")
                .font(.title2)
                .fontWeight(.bold)
            
            ScrollWithSnap(
                widthOfEachItem: size.width * 0.75,
                heightOfEachItem: 150,
                spacing: 18,
                items: vm.topRatedMovies.count) {
                    ForEach(vm.topRatedMovies) { movie in
                        Button {
                            showDetail = true
                            selectedMovie = movie
                        } label: {
                            ImageView(url: "\(APIEndpoints.imageBaseUrl)/w185/\(movie.wrappedBackdropPath)")
                                .frame(width: size.width * 0.75, height: 150)
                                .cornerRadius(10)
                        }
                    }
                    .buttonStyle(.plain)
                }.frame(width: size.width * 0.75, height: 150)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 200)
        .padding(.vertical)
    }
    
    private var upcomingMoviesList: some View {
        VStack(alignment: .leading) {
            Text("upcoming")
                .font(.title2)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 28) {
                    ForEach(vm.upcomingMovies) { movie in
                        Button {
                            showDetail = true
                            selectedMovie = movie
                        } label: {
                            MovieCardView(movie: movie)
                                .frame(width: size.width * 0.4 , height: 300)
                                .cornerRadius(12)
                        }.buttonStyle(.plain)
                    }
                }
            }
            .accessibilityIdentifier("UpcomingMovieList")
            .padding(.vertical)
        }
    }
}
