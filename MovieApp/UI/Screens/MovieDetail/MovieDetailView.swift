//
//  MovieDetailView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 13/03/2022.
//

import SwiftUI
//import AlertToast

struct MovieDetailView: View {
    
    let movie: Movie
    
    @EnvironmentObject private var appState: AppState
    @StateObject private var vm: MovieDetailViewModel
    @State private var size: CGSize = .zero
    
    private let gridItems = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let linearGradient = LinearGradient(stops: [
        Gradient.Stop(color: Color.theme.background.opacity(0.1), location: 0),
        Gradient.Stop(color: Color.theme.background, location: 0.6)
    ], startPoint: .top, endPoint: .bottom)
    
    init(movie: Movie, authService: MovieDBAuthProtocol, favoriteService: FavoritedDataServiceProtocol) {
        self.movie = movie
        _vm = StateObject(wrappedValue: MovieDetailViewModel(
            movie: movie,
            dataService: MovieDataService(),
            authService: authService,
            favoriteService: favoriteService
        ))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.theme.background
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                ScrollView {
                    if vm.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        ZStack(alignment: .top) {
                            ImageView(url: "\(APIEndpoints.imageBaseUrl)/w154/\(vm.currentMovie.wrappedBackdropPath)")
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.height / 3)
                                .opacity(0.75)
                                .blur(radius: 10)
                            
                            linearGradient
                            
                            VStack(alignment: .leading, spacing: 20) {
                                movieHeader
                                movieOverview
                                movieStats
                                productionCountries
                                if vm.videos.isNotEmpty {
                                    // TODO: Too many WKWebViews would result to large memory usage
                                    gallery
                                }
                                cast
                                similarMovies
                                reviews
                            }
                            .frame(maxHeight: .infinity)
                            .padding(.top, geometry.size.height * 0.15)
                            .padding(.bottom, geometry.size.height * 0.2)
                        }
                        
                    }
                }
                .ignoresSafeArea()
                .onAppear {
                    size = geometry.size
                }
            }
        }
        .onReceive(appState.authService.isAuthenticatedPublisher, perform: { isAuthenticated in
            if isAuthenticated {
                vm.getFavoriteStatus()
            }
        })
        .alert(LocalizedStringKey(vm.toastMsg ?? ""), isPresented: $appState.showingToast, actions: {
            Button("OK", role: .cancel) {
            }
        })
        // TODO: Another leaks again
        //        .toast(isPresenting: $appState.showingToast, tapToDismiss: false) {
        //            AlertToast(displayMode: .banner(.slide), type: .regular, title: vm.toastMsg)
        //        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { [weak appState, weak vm] in
                    if vm?.authService.isAuthenticated == true {
                        vm?.favorite(showToast: appState?.showToast)
                    } else {
                        // else show guest
                        appState?.showSignInScreen()
                    }
                } label: {
                    if vm.isFavorited {
                        Image(systemName: "heart.fill")
                            .foregroundColor(Color.theme.primary)
                    } else {
                        Image(systemName: "heart")
                            .foregroundColor(.white)
                    }
                }
                .accessibilityIdentifier("FavoriteBtn")
                .opacity(vm.isLoading || vm.isFavorited ? 0.5 : 1.0)
                .disabled(vm.isLoading || vm.isFavorited)
            }
        }
    }
    
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                MovieDetailView(movie: Movie.fakedMovie2, authService: MovieDBAuthService(),
                                favoriteService: FavoritedDataService()
                )
                    .preferredColorScheme(.dark)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .environmentObject(AppState())
            .foregroundColor(.white)
            .environment(\.locale, .init(identifier: "en"))
            .previewDisplayName("eng")
            
            NavigationView {
                MovieDetailView(movie: Movie.fakedMovie2, authService: MovieDBAuthService(),
                                favoriteService: FavoritedDataService()
                )
                    .preferredColorScheme(.dark)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .environmentObject(AppState())
            .foregroundColor(.white)
            .environment(\.locale, .init(identifier: "zh-Hans"))
            .previewDisplayName("cn")
        }
    }
}

extension MovieDetailView {
    
    private var movieHeader: some View {
        HStack(spacing: 20) {
            ImageView(url: "\(APIEndpoints.imageBaseUrl)/w300/\(vm.currentMovie.wrappedPosterPath)")
                .scaledToFill()
                .frame(width: size.width * 0.35, height: size.height / 3.5)
                .cornerRadius(10)
                .clipped()
            
            VStack(alignment: .leading, spacing: 12) {
                Text(vm.currentMovie.wrappedTitle)
                    .font(.title2)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityIdentifier("MovieTitle")
                    .textSelection(.enabled)
                
                RatingView(rating: vm.currentMovie.wrappedVoteAverage)
                    .font(.caption)
                
                Text(vm.currentMovie.wrappedReleaseDate)
                    .padding(.bottom)
                    .opacity(0.65)
                
                Button("Book now") { }
                .padding()
                .font(.callout.bold())
                .background(Color.theme.primary)
                .cornerRadius(6)
            }
            .foregroundColor(.white)
            
            Spacer()
            
        }
        .padding()
    }
    
    private var movieStats: some View {
        LazyVGrid(columns: gridItems) {
            StatsInfoView(
                icon: "dollarsign.circle.fill",
                title: "movie_stat_revenue_label",
                value: "$ \(vm.currentMovie.wrappedRevenue)")
                .overlay(RoundedRectangle(cornerRadius: 12.0).stroke(.gray.opacity(0.2), lineWidth: 2.5))
            StatsInfoView(
                icon: "play.circle.fill",
                title: "movie_stat_runtime_label",
                value: LocalizedStringKey("movie_stat_runtime_minutes \(vm.currentMovie.wrappedRuntime)"),
                valueWithPlurals: true)
                .overlay(RoundedRectangle(cornerRadius: 12.0).stroke(.gray.opacity(0.2), lineWidth: 2.5))
            StatsInfoView(
                icon: "list.star",
                title: "movie_stat_voting_label",
                value: LocalizedStringKey("movie_stat_people_voted \(vm.currentMovie.wrappedVoteCount)"))
                .overlay(RoundedRectangle(cornerRadius: 12.0).stroke(.gray.opacity(0.2), lineWidth: 2.5))
            
            if vm.currentMovie.wrappedAdult {
                StatsInfoView(
                    icon: "18.circle.fill",
                    title: "movie_stat_adult_label",
                    value: LocalizedStringKey("movie_stat_adult_text"))
                    .overlay(RoundedRectangle(cornerRadius: 12.0).stroke(.gray.opacity(0.2), lineWidth: 2.5))
            }
        }
        .padding([.top, .horizontal])
    }
    
    private var productionCountries: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("movie_production_countries")
                    .font(.headline)
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 18) {
                    if let countries = vm.currentMovie.productionCountries, countries.isNotEmpty {
                        ForEach(countries) { country in
                            CountryView(country: country)
                        }
                    } else {
                        Text("no_result")
                            .foregroundColor(.white)
                            .opacity(0.65)
                    }
                }
            }
        }.padding([.top, .horizontal])
    }
    
    private var movieOverview: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("movie_storyline")
                .font(.headline)
            
            Text(vm.currentMovie.wrappedOverview)
                .font(.callout)
                .opacity(0.65)
                .textSelection(.enabled)
        }
        .padding(.horizontal)
        .foregroundColor(.white)
    }
    
    private var reviews: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("movie_reviews")
                .font(.headline)
            
            LazyVStack(spacing: 18) {
                if vm.reviews.isNotEmpty {
                    ForEach(vm.reviews) { review in
                        autoreleasepool {
                            ReviewView(review: review)
                                .onAppear {
                                    // Continue fetch next pages after reaching to bottom.
                                    if review == vm.reviews.last {
                                        vm.loadReviews(nextPage: true)
                                    }
                                }
                        }
                    }
                } else {
                    Text("movie_reviews_empty")
                        .opacity(0.65)
                }
            }
            
        }
        .padding(.horizontal)
        .foregroundColor(.white)
    }
    
    private var gallery: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("movie_galleries")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(vm.videos) { video in
                        YoutubeView(videoID: video.key ?? "")
                            .frame(width: size.width / 1.25, height: size.height * 0.2)
                    }
                }
            }
        }
        .padding()
    }
    
    private var cast: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            HStack {
                Text("movie_casts")
                    .font(.headline)
                Spacer()
                
                if let crew = vm.crew {
                    NavigationLink {
                        CrewListView(crew: crew)
                    } label: {
                        Text("view_all")
                            .font(.caption)
                            .padding([.leading, .bottom])
                            .accessibilityIdentifier("ViewMoreCasts")
                    }
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 18) {
                    if vm.top10Cast.isNotEmpty {
                        ForEach(vm.top10Cast) { cast in
                            CrewView(person: cast)
                        }
                    } else {
                        Text("no_result")
                            .foregroundColor(.white)
                            .opacity(0.65)
                    }
                }
            }
        }
        .padding()
    }
    
    private var similarMovies: some View {
        VStack(alignment: .leading) {
            Text("movie_similar")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 28) {
                    ForEach(vm.similarMovies) { movie in
                        NavigationLink {
                            MovieDetailView(
                                movie: movie,
                                authService: appState.authService,
                                favoriteService: appState.favoriteService
                            )
                        } label: {
                            MovieCardView(movie: movie)
                                .frame(width: 150, height: 200)
                                .cornerRadius(12)
                        }
                        .isDetailLink(false)
                        .buttonStyle(PlainButtonStyle())
                    }
                }.padding()
            }
        }
    }
}
