//
//  ContentViewModel.swift
//  Wordlist-Game
//
//  Created by Alexander Khitev on 7/7/22.
//

import Foundation

final class ContentViewModel: ObservableObject {
    private var allPairs = [WordPair]()

    @Published var currentGameSessionPairs = [WordPair]()
    var currentGameSessionPair: WordPair? {
        currentGameSessionPairs.first
    }

    @Published var correctAttemptsCount = 0
    @Published var incorrectAttemptsCount = 0
    @Published var gameSessionContinues = true {
        didSet {
            guard !gameSessionContinues else { return }
            invalidateCurrentTimer()
        }
    }
    @Published var showsAlert = false

    private var timer: Timer?

    private struct Consts {
        static let gameSessionWordPairsNumber = 15
        static let correctWordPairsNumber: Int = {
            Int((Double(gameSessionWordPairsNumber) / 100 * 25).rounded())
        }()
        static let incorrectWordPairsNumber: Int = {
            gameSessionWordPairsNumber - correctWordPairsNumber
        }()
        static let maxIncorrectAttempts = 3
        static let timeForAnswer: TimeInterval = 5
    }

    init() {
        loadPairs()
        startNewGameSession()
    }

    private func loadPairs() {
        /*
         App should load `words.json` file from the file system according the docs
         Otherwise I'll use just `bundleURL`
         */
        guard let bundleURL = Bundle.main.url(forResource: "words", withExtension: "json") else { return }
        let jsonDecoder = JSONDecoder()
        do {
            let jsonURL = try FileManager.default.copyFileToDocsFolder(bundleURL)
            allPairs = try jsonDecoder.decode([WordPair].self, from: jsonURL)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    private func clearCurrentGameSessionData() {
        invalidateCurrentTimer()
        correctAttemptsCount = 0
        incorrectAttemptsCount = 0
    }

    func startNewGameSession() {
        clearCurrentGameSessionData()
        gameSessionContinues = true

        var allPairs = allPairs.shuffled()
        let correctPairs = allPairs.prefix(Consts.correctWordPairsNumber)
        allPairs = Array(allPairs.dropFirst(Consts.correctWordPairsNumber))
        var incorrectPairs = [WordPair]()

        for _ in 0..<Consts.incorrectWordPairsNumber {
            guard let firstPair = allPairs.popLast(), let secondPair = allPairs.popLast() else { break }
            let incorrectPair = WordPair(textEng: firstPair.textEng, textSpa: secondPair.textSpa, option: .incorrect)
            incorrectPairs.append(incorrectPair)
        }
        currentGameSessionPairs = (correctPairs + incorrectPairs).shuffled()
        launchTimerIfNeeded()
    }

    // MARK: - Timer logic

    private func launchTimerIfNeeded() {
        guard gameSessionContinues else { return }
        timer = Timer.scheduledTimer(withTimeInterval: Consts.timeForAnswer, repeats: false, block: { [weak self] _ in
            self?.markAsIncorrectAttempt()
        })
    }

    private func invalidateCurrentTimer() {
        timer?.invalidate()
        timer = nil
    }

    func choose(option: Option) {
        guard let currentGameSessionPair = currentGameSessionPair else {
            return
        }
        invalidateCurrentTimer()
        if currentGameSessionPair.option == option {
            correctAttemptsCount += 1
        } else {
            incorrectAttemptsCount += 1
        }
        showNextPair()

        checkGameSessionStatus()
        launchTimerIfNeeded()
    }

    private func markAsIncorrectAttempt() {
        incorrectAttemptsCount += 1
        showNextPair()
        checkGameSessionStatus()
        launchTimerIfNeeded()
    }

    private func showNextPair() {
        currentGameSessionPairs.removeFirst()
    }

    private func checkGameSessionStatus() {
        gameSessionContinues = incorrectAttemptsCount != Consts.maxIncorrectAttempts
        showsAlert = !gameSessionContinues
    }

}
