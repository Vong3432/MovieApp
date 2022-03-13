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
        _vm = StateObject(wrappedValue: MovieDetailViewModel(movie: movie))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.theme.background
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                VStack {
                    ScrollView {
                        ZStack(alignment: .top) {
                            MovieImageView(url: movie.wrappedBackdropPath)
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.height / 3)
                                .opacity(0.75)
                                .blur(radius: 10)
                            
                            linearGradient
                            
                            VStack(alignment: .leading, spacing: 20) {
                                movieHeader
                                movieOverview
                                //                                casts
                                gallery
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
            MovieImageView(url: movie.wrappedPosterPath)
                .scaledToFill()
                .frame(width: size.width * 0.35, height: size.height / 3.5)
                .cornerRadius(10)
                .clipped()
            
            VStack(alignment: .leading, spacing: 18) {
                Text(movie.wrappedTitle)
                    .font(.title2)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxHeight: .infinity)
                
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
        VStack(alignment: .leading, spacing: 12) {
            Text("Storyline")
                .font(.title2)
            
            Text(movie.wrappedOverview)
                .font(.body)
//                .lineLimit(nil)
//                .fixedSize(horizontal: false, vertical: true)
//                .frame(maxHeight: .infinity)
                .opacity(0.65)
        }
        .padding(.horizontal)
        .foregroundColor(.white)
    }
    
    private var casts: some View {
        ScrollView(.horizontal) {
            VStack(alignment: .leading) {
                
            }
        }
    }
    
    private var gallery: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Galleries")
                .font(.title2)
            
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(vm.videos, id: \.id) { video in
                        generateYoutubeVideo(
                            url: "https://youtube.com/watch?v=\(video.key ?? "")")
                    }
                }
            }
        }.padding()
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
            case .error(let error):
                Text(verbatim: "YouTube player couldn't be loaded")
            }
        }
        .frame(width: size.width / 1.25, height: size.height * 0.3)
    }
}
