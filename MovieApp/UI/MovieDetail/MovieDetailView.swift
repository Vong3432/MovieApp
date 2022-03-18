//
//  MovieDetailView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 13/03/2022.
//

import SwiftUI
import YouTubePlayerKit

struct MovieDetailView: View {
    
    let movie: Movie
    
    @StateObject private var vm: MovieDetailViewModel
    
    @State private var size: CGSize = .zero
    
    private let linearGradient = LinearGradient(stops: [
        Gradient.Stop(color: Color.theme.background.opacity(0.1), location: 0),
        Gradient.Stop(color: Color.theme.background, location: 0.6)
    ], startPoint: .top, endPoint: .bottom)
    
    init(movie: Movie) {
        self.movie = movie
        _vm = StateObject(wrappedValue: MovieDetailViewModel(movie: movie, dataService: MovieDataService()))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.theme.background
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                VStack {
                    ScrollView {
                        ZStack(alignment: .top) {
                            ImageView(url: movie.wrappedBackdropPath)
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.height / 3)
                                .opacity(0.75)
                                .blur(radius: 10)
                            
                            linearGradient
                            
                            LazyVStack(alignment: .leading, spacing: 20) {
                                movieHeader
                                movieOverview
                                gallery
                                cast
                                reviews
                            }
                            .frame(maxHeight: .infinity)
                            .padding(.top, geometry.size.height * 0.15)
                            .padding(.bottom, geometry.size.height * 0.2)
                        }
                    }
                    .ignoresSafeArea()
                }
                .onAppear {
                    size = geometry.size
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.white)
            }
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieDetailView(movie: DeveloperPreview.mockMovie)
                .navigationBarHidden(true)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension MovieDetailView {
    
    private var movieHeader: some View {
        HStack(spacing: 20) {
            ImageView(url: movie.wrappedPosterPath)
                .scaledToFill()
                .frame(width: size.width * 0.35, height: size.height / 3.5)
                .cornerRadius(10)
                .clipped()
            
            VStack(alignment: .leading, spacing: 12) {
                Text(movie.wrappedTitle)
                    .font(.title2)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                RatingView(rating: movie.wrappedVoteAverage)
                    .font(.caption)
                
                Text(movie.wrappedReleaseDate)
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
    
    private var movieOverview: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Storyline")
                .font(.headline)
            
            Text(movie.wrappedOverview)
                .font(.callout)
                .opacity(0.65)
        }
        .padding(.horizontal)
        .foregroundColor(.white)
    }
    
    private var reviews: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Reviews")
                .font(.headline)
            
            ScrollView {
                LazyVStack(spacing: 18) {
                    if vm.reviews.isNotEmpty {
                        ForEach(vm.reviews) { review in
                            ReviewView(review: review)
                        }
                    } else {
                        Text("No reviews yet")
                            .opacity(0.65)
                    }
                }
            }
        }
        .padding(.horizontal)
        .foregroundColor(.white)
    }
    
    private var gallery: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Galleries")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(vm.videos) { video in
                        generateYoutubeVideo(
                            url: "https://youtube.com/watch?v=\(video.key ?? "")")
                    }
                }
            }
        }
        .padding()
    }
    
    private var cast: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            HStack {
                Text("Casts")
                    .font(.headline)
                Spacer()
                
                if let crew = vm.crew {
                    NavigationLink {
                        CrewListView(crew: crew)
                    } label: {
                        Text("View all")
                            .font(.caption)
                            .padding([.leading, .bottom])
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
                        Text("No result")
                            .foregroundColor(.white)
                            .opacity(0.65)
                    }
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private func generateYoutubeVideo(url: String) -> some View {
        let url: YouTubePlayer = YouTubePlayer(stringLiteral: url)
        
        YouTubePlayerView(url) { state in
            switch state {
            case .idle:
                ProgressView()
            case .ready:
                EmptyView()
            case .error(_):
                Text(verbatim: "YouTube player couldn't be loaded")
            }
        }
        .frame(width: size.width / 1.25, height: size.height * 0.2)
    }
}
