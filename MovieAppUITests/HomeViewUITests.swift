//
//  HomeViewUITests.swift
//  MovieAppUITests
//
//  Created by Vong Nyuksoon on 28/05/2022.
//

import XCTest

// Naming structure: test_unitOfWork_stateUnderTest_expectedBehavior
// Naming structure: test_[struct]_[ui component]_[expectedBehavior]
// Testing structure: Given, When, Then
class HomeViewUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // set app to test env
        app.launchEnvironment = ["UITESTS":"1"]

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
    }
    
    func test_HomeView_list_shoudLoadData() {
        
        measure {
            // Given
            let homeList = app.tables["HomeList"]
            let ratedMovieList = homeList.scrollViews["TopRatedMovieList"]
            let upcomingMovieList = homeList.scrollViews["TopRatedMovieList"]
            
            // When
//            sleep(1)
            
            // Then
            XCTAssertTrue(ratedMovieList.exists)
            XCTAssertTrue(upcomingMovieList.exists)
        }
        
    }

    func test_HomeView_list_shouldRefreshWhenPull() {
        // Given
        let firstCell = app.tables["HomeList"].cells.firstMatch
        let start = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let finish = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 10))
        
        // wait 3 secs to ensure page is loaded
        sleep(3)
        XCTAssertTrue(firstCell.exists)

        // When
        start.press(forDuration: 0, thenDragTo: finish) // pull-to-refresh
        
        // wait 3 secs again
        sleep(3)

        // Then
        XCTAssertTrue(firstCell.exists)
    }

}
