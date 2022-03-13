//
//  HomeView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            ScrollView {
                topRatedMoviesList
                upcomingMoviesList
            }.padding(.bottom)
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
                ForEach(vm.topRatedMovies, id: \.id) { movie in
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
                    ForEach(vm.upcomingMovies, id: \.id) { movie in
                        MovieCardView(movie: movie)
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    }
                }
                .padding()
            }
        }
    }
}
