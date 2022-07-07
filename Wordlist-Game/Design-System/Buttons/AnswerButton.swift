//
//  AnswerButton.swift
//  Wordlist-Game
//
//  Created by Alexander Khitev on 7/7/22.
//

import SwiftUI

struct AnswerButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            action()
        } label: {
            Text(title)
                .font(.title)
                .foregroundColor(.black)
                .background(.white)
                .padding(.horizontal, 8)
                .frame(minWidth: 100)
                .frame(minHeight: 40)
                .background(
                    Rectangle()
                        .fill(.white)
                        .shadow(color: .black, radius: 2, x: 2, y: 2)
                )
        }
        .border(.black, width: 1)
    }
}

struct AnswerButton_Previews: PreviewProvider {
    static var previews: some View {
        AnswerButton(title: "Hello", action: { })
    }
}

