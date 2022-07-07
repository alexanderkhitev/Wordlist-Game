//
//  ContentView.swift
//  Wordlist-Game
//
//  Created by Alexander Khitev on 7/7/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject
    private var viewModel = ContentViewModel()

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()
                VStack(alignment: .trailing, spacing: 12) {
                    Text("Correct attempts: \(viewModel.correctAttemptsCount)")
                    Text("Wrong attempts: \(viewModel.incorrectAttemptsCount)")
                }
            }
            .padding()
            Spacer()
            VStack(alignment: .center, spacing: 60) {
                Text(viewModel.currentGameSessionPair?.textSpa ?? "")
                    .font(.largeTitle)
                Text(viewModel.currentGameSessionPair?.textEng ?? "")
                    .font(.title)
            }
            .multilineTextAlignment(.center)
            Spacer()
            HStack(spacing: 28) {
                AnswerButton(title: "Correct") {
                    viewModel.choose(option: .correct)
                }
                AnswerButton(title: "Wrong") {
                    viewModel.choose(option: .incorrect)
                }
            }
        }
        .padding(.horizontal, 20)
        .alert(Text("The game session is finished"), isPresented: $viewModel.showsAlert) {
            Button("Restart the game") {
                viewModel.startNewGameSession()
            }
            Button("Quit the game") {
                // according the code challenge requirements
                fatalError()
            }
        } message: {
            Text("The final score: \(viewModel.correctAttemptsCount)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
