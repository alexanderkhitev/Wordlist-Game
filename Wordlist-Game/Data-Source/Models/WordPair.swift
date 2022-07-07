//
//  WordPair.swift
//  Wordlist-Game
//
//  Created by Alexander Khitev on 7/7/22.
//

import Foundation

struct WordPair: Decodable {
    var textEng: String
    var textSpa: String
    var option: Option

    enum Key: String, CodingKey {
        case textEng = "text_eng"
        case textSpa = "text_spa"
    }

    init(textEng: String, textSpa: String, option: Option) {
        self.textEng = textEng
        self.textSpa = textSpa
        self.option = option
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        textEng = try container.decode(String.self, forKey: .textEng)
        textSpa = try container.decode(String.self, forKey: .textSpa)
        option = .correct
    }
}
