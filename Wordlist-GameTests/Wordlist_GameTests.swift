//
//  Wordlist_GameTests.swift
//  Wordlist-GameTests
//
//  Created by Alexander Khitev on 7/7/22.
//

import XCTest
@testable import Wordlist_Game

class Wordlist_GameTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAppBundleContainsWordsJSON() throws {
        let wordsJSONFileURL = Bundle.main.url(forResource: "words", withExtension: "json")
        XCTAssertNotNil(wordsJSONFileURL)
    }

    func testDecodingWordsJSON() throws {
        let url = Bundle.main.url(forResource: "words", withExtension: "json")!
        let wordPairs = try JSONDecoder().decode([WordPair].self, from: url)
        XCTAssertGreaterThan(wordPairs.count, 0)
    }

    func testContentViewModelInitState() {
        let vm = ContentViewModel()
        XCTAssertNotEqual(vm.allPairs.count, 0)
        XCTAssertEqual(vm.gameSessionContinues, true)
        XCTAssertEqual(vm.currentGameSessionPairs.count, ContentViewModel.Consts.gameSessionWordPairsNumber)

        let correctWordPairsCount = vm.currentGameSessionPairs.filter({ $0.option == .correct }).count
        XCTAssertEqual(correctWordPairsCount, ContentViewModel.Consts.correctWordPairsNumber)

        let incorrectWordPairsCount = vm.currentGameSessionPairs.filter({ $0.option == .incorrect }).count
        XCTAssertEqual(incorrectWordPairsCount, ContentViewModel.Consts.incorrectWordPairsNumber)
    }

    func testUpdateWordPairsAfterNewGameStart() {
        let vm = ContentViewModel()
        let initialWordPairs = vm.currentGameSessionPairs
        vm.startNewGameSession()
        let newWordPairs = vm.currentGameSessionPairs
        XCTAssertNotEqual(newWordPairs, initialWordPairs)
    }

    func testPropertiesAfterNewGameStart() {
        let vm = ContentViewModel()
        vm.incorrectAttemptsCount = 2
        vm.correctAttemptsCount = 12
        vm.gameSessionContinues = false

        vm.startNewGameSession()

        XCTAssertEqual(vm.gameSessionContinues, true)
        XCTAssertEqual(vm.correctAttemptsCount, 0)
        XCTAssertEqual(vm.incorrectAttemptsCount, 0)
        XCTAssertEqual(vm.showsAlert, false)
        XCTAssertNotNil(vm.currentGameSessionPair)
    }

}
