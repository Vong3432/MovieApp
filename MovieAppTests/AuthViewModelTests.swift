//
//  AuthViewModelTests.swift
//  MovieAppTests
//
//  Created by Vong Nyuksoon on 27/05/2022.
//

import XCTest
@testable import MovieApp

// Naming structure: test_unitOfWork_stateUnderTest_expectedBehavior
// Naming structure: test_[struct/class]_[variable/function]_[expectedBehavior]
// Testing structure: Given, When, Then
class AuthViewModelTests: XCTestCase {
    
    typealias AuthViewModel = AuthView.AuthViewModel

    override class func setUp() {
        super.setUp()
    }
    
    weak var weakSut: AnyObject?
    
    func makeSUT(authService: MovieDBAuthProtocol) -> AuthViewModel {
        let vm = AuthViewModel(authService: authService)
        
        self.weakSut = vm
        
        return vm
    }
    
    override func tearDown() async throws {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        try await super.tearDown()
        XCTAssertNil(weakSut)
    }

    func test_AuthViewModel_handleSignIn_success() async {
        // Given
        let mockAuthService = MockMovieDBAuthService()
        let vm = makeSUT(authService: mockAuthService)
        
        // When
        await vm.handleSignIn()
        
        // Then
        XCTAssertNil(vm.errorMsg)
    }
    
    func test_AuthViewModel_handleSignIn_fail_shouldSetErrorMsg() async {
        // Given
        let mockAuthService = MockMovieDBAuthServiceFail()
        let vm = makeSUT(authService: mockAuthService)
        
        // When
        await vm.handleSignIn()
        
        // Then
        XCTAssertNotNil(vm.errorMsg)
    }
}
