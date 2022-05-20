//
//  HomeView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel(dataService: MovieDataService())
    @State private var size: CGSize = .zero
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                Color.theme.background
                    .ignoresSafeArea()
                
                ScrollView {
                    topRatedMoviesList
                    upcomingMoviesList
                }
                .padding(.bottom)
                .onAppear {
                    size = geo.size
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationTitle("Movies")
        }.preferredColorScheme(.dark)
    }
}

extension HomeView {
    private var topRatedMoviesList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 28) {
                ForEach(vm.topRatedMovies) { movie in
                    NavigationLink {
                        MovieDetailView(movie: movie)
                    } label: {
                        MovieCardView(movie: movie)
                            .frame(height: 400)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
    
    private var upcomingMoviesList: some View {
        VStack(alignment: .leading) {
            Text("Upcoming")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 28) {
                    ForEach(vm.upcomingMovies) { movie in
                        NavigationLink {
                            MovieDetailView(movie: movie)
                        } label: {
                            MovieCardView(movie: movie)
                                .frame(width: size.width * 0.4 , height: 300)
                                .clipped()
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
        }
    }
}
