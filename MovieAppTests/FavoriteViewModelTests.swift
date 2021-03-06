//
//  FavoriteViewModelTests.swift
//  MovieAppTests
//
//  Created by Vong Nyuksoon on 27/05/2022.
//

import XCTest
@testable import MovieApp

// Naming structure: test_unitOfWork_stateUnderTest_expectedBehavior
// Naming structure: test_[struct/class]_[variable/function]_[expectedBehavior]
// Testing structure: Given, When, Then
class FavoriteViewModelTests: XCTestCase {
    
    typealias FavoriteViewModel = FavoriteView.FavoriteViewModel

    override class func setUp() {
        super.setUp()
    }
    
    weak var weakSut: AnyObject?
    
    func makeSUT(authService: MovieDBAuthProtocol, dataService: FavoritedDataServiceProtocol) -> FavoriteViewModel {
        let vm = FavoriteViewModel(authService: authService, dataService: dataService)
        
        self.weakSut = vm
        
        return vm
    }
    
    override func tearDown() async throws {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        try await super.tearDown()
        XCTAssertNil(weakSut)
    }

    // Named forOnce because the param ``nextPage`` is for continuos loading for more data.
    func test_FavoriteViewModel_loadFavorite_shouldSuccess_forOnce() async {
        // Given
        let mockedDBAuthService = MockMovieDBAuthService()
        let mockedFavoriteDataService = MockFavoritedDataService()
        let vm = makeSUT(authService: mockedDBAuthService, dataService: mockedFavoriteDataService)
        
        // When
        // mock login
        try? await mockedDBAuthService.login(username: "asd", password: "ad")
        await vm.loadFavorites()
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Then
        XCTAssertTrue(vm.favoriteList.isNotEmpty)
        XCTAssertFalse(vm.isLoading)
        XCTAssertFalse(vm.isFetchingMore)
    }
    
    // Named forOnce because the param ``nextPage`` is for continuos loading for more data.
    func test_FavoriteViewModel_loadFavorite_shouldFail_forOnce() async {
        // Given
        let mockedDBAuthService = MockMovieDBAuthService()
        let mockedFavoriteDataService = MockFavoritedDataServiceFail()
        let vm = makeSUT(authService: mockedDBAuthService, dataService: mockedFavoriteDataService)
        
        // When
        // mock login
        try? await mockedDBAuthService.login(username: "asd", password: "ad")
        await vm.loadFavorites()
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Then
        XCTAssertTrue(vm.favoriteList.isEmpty)
        XCTAssertFalse(vm.isLoading)
        XCTAssertFalse(vm.isFetchingMore)
    }
    
    func test_FavoriteViewModel_loadMore_shouldSuccess() async {
        // Given
        let mockedDBAuthService = MockMovieDBAuthService()
        let mockedFavoriteDataService = MockFavoritedDataService()
        let vm = makeSUT(authService: mockedDBAuthService, dataService: mockedFavoriteDataService)

        // mock login
        try? await mockedDBAuthService.login(username: "asd", password: "ad")
        await vm.loadFavorites()
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        XCTAssertTrue(vm.favoriteList.isNotEmpty)
        XCTAssertFalse(vm.isLoading)
        XCTAssertFalse(vm.isFetchingMore)
        
        let prevFavoriteListCount = vm.favoriteList.count
        
        // When
        await vm.loadMore()
        
        // Then
        XCTAssertNotEqual(vm.favoriteList.count, prevFavoriteListCount)
    }
    
    func test_FavoriteViewModel_loadMore_shouldFail() async {
        // Given
        let mockedDBAuthService = MockMovieDBAuthService()
        let mockedFavoriteDataService = MockFavoritedDataServiceFail()
        let vm = makeSUT(authService: mockedDBAuthService, dataService: mockedFavoriteDataService)

        // mock login
        try? await mockedDBAuthService.login(username: "asd", password: "ad")
        await vm.loadFavorites()
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        XCTAssertTrue(vm.favoriteList.isEmpty)
        XCTAssertFalse(vm.isLoading)
        XCTAssertFalse(vm.isFetchingMore)
        
        let prevFavoriteListCount = vm.favoriteList.count
        
        // When
        await vm.loadMore()
        
        // Then
        XCTAssertEqual(vm.favoriteList.count, prevFavoriteListCount)
    }
    
    func test_FavoriteViewModel_refresh_shouldSuccess() async {
        // Given
        let mockedDBAuthService = MockMovieDBAuthService()
        let mockedFavoriteDataService = MockFavoritedDataService()
        let vm = makeSUT(authService: mockedDBAuthService, dataService: mockedFavoriteDataService)

        // mock login
        try? await mockedDBAuthService.login(username: "asd", password: "ad")
        await vm.loadFavorites()
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        let firstLoadFavoriteListCount = vm.favoriteList.count
        
        XCTAssertTrue(vm.favoriteList.isNotEmpty)
        XCTAssertFalse(vm.isLoading)
        XCTAssertFalse(vm.isFetchingMore)
        
        await vm.loadMore()
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let afterLoadFavoriteListCount = vm.favoriteList.count
        
        // When
        await vm.refresh()
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Then
        XCTAssertEqual(vm.favoriteList.count, firstLoadFavoriteListCount) // 21 == 21
        XCTAssertNotEqual(vm.favoriteList.count, afterLoadFavoriteListCount) // 21 != 41
    }
    
    func test_FavoriteViewModel_refresh_shouldFail() async {
        // Given
        let mockedDBAuthService = MockMovieDBAuthService()
        let mockedFavoriteDataService = MockFavoritedDataServiceFail()
        let vm = makeSUT(authService: mockedDBAuthService, dataService: mockedFavoriteDataService)

        // mock login
        try? await mockedDBAuthService.login(username: "asd", password: "ad")
        await vm.loadFavorites()
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        XCTAssertTrue(vm.favoriteList.isEmpty)
        XCTAssertFalse(vm.isLoading)
        XCTAssertFalse(vm.isFetchingMore)
        
        await vm.loadMore()
        
        // When
        await vm.refresh()
        
        // Then
        XCTAssertEqual(vm.favoriteList.count, 0)
    }
}
