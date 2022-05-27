//
//  MovieDetailViewModelTests.swift
//  MovieAppTests
//
//  Created by Vong Nyuksoon on 26/05/2022.
//

import XCTest
@testable import MovieApp

// Naming structure: test_unitOfWork_stateUnderTest_expectedBehavior
// Naming structure: test_[struct/class]_[variable/function]_[expectedBehavior]
// Testing structure: Given, When, Then
class MovieDetailViewModelTests: XCTestCase {
    typealias MovieDetailViewModel = MovieDetailView.MovieDetailViewModel
    
    override class func setUp() {
        super.setUp()
    }

    func test_MovieDetailViewModel_fetchMovieInfo_shouldSuccess() async {
        // Given
        let mockMovieDataService = MockMovieDataService()
        let mockMovieAuthService = MockMovieDBAuthService()
        let mockFavoriteDataService = MockFavoritedDataService()
        let vm = MovieDetailViewModel(movie: .fakedMovie, dataService: mockMovieDataService, authService: mockMovieAuthService, favoriteService: mockFavoriteDataService)
        
        // When
        // user is logged in
        try? await mockMovieAuthService.login(username: "asd", password: "asd")
        vm.fetchMovieInfo(.fakedMovie)
        XCTAssertTrue(vm.isLoading)
        
        let cb = expectation(description: "Loaded success")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            cb.fulfill()
        }
        
        // Then
        wait(for: [cb], timeout: 5)
        XCTAssertNotNil(vm.currentMovie)
        XCTAssertNotNil(vm.crew)
        XCTAssertNil(vm.toastMsg)
        XCTAssertFalse(vm.isLoading)
        XCTAssertTrue(vm.videos.count > 0)
    }
    
    func test_MovieDetailViewModel_fetchMovieInfo_shouldFail() async {
        // Given
        let mockMovieDataService = MockMovieDataServiceFail()
        let mockMovieAuthService = MockMovieDBAuthService()
        let mockFavoriteDataService = MockFavoritedDataServiceFail()
        let vm = MovieDetailViewModel(movie: .fakedMovie, dataService: mockMovieDataService, authService: mockMovieAuthService, favoriteService: mockFavoriteDataService)
        
        // When
        // user is logged in
        try? await mockMovieAuthService.login(username: "asd", password: "asd")
        vm.fetchMovieInfo(.fakedMovie)
        XCTAssertTrue(vm.isLoading)
        
        let cb = expectation(description: "Loaded failed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            cb.fulfill()
        }
        
        // Then
        wait(for: [cb], timeout: 5)
        XCTAssertNil(vm.crew)
        XCTAssertFalse(vm.isLoading)
        XCTAssertFalse(vm.videos.count > 0)
    }
}
