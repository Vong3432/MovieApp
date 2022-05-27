//
//  HomeViewModelTests.swift
//  MovieAppTests
//
//  Created by Vong Nyuksoon on 26/05/2022.
//

import XCTest
@testable import MovieApp

// Naming structure: test_unitOfWork_stateUnderTest_expectedBehavior
// Naming structure: test_[struct/class]_[variable/function]_[expectedBehavior]
// Testing structure: Given, When, Then
class HomeViewModelTests: XCTestCase {
    
    typealias HomeViewModel = HomeView.HomeViewModel

    override func setUp() {
        super.setUp()
    }

    func test_HomeViewModel_loadData_success() {
        // Given
        let mockMovieDataService = MockMovieDataService()
        let vm = HomeViewModel(dataService: mockMovieDataService)
        
        // When
        vm.loadData()
        
        // Then
        XCTAssertTrue(vm.topRatedMovies.isNotEmpty)
        XCTAssertTrue(vm.upcomingMovies.isNotEmpty)
    }
    
    func test_HomeViewModel_loadData_fail() {
        // Given
        let mockMovieDataService = MockMovieDataServiceFail()
        let vm = HomeViewModel(dataService: mockMovieDataService)
        
        // When
        vm.loadData()
        
        // Then
        XCTAssertTrue(vm.topRatedMovies.isEmpty)
        XCTAssertTrue(vm.upcomingMovies.isEmpty)
    }
}
