//
//  JSONDecoder.swift
//  Wordlist-Game
//
//  Created by Alexander Khitev on 7/7/22.
//

import Foundation

extension JSONDecoder {
    func decode<T>(_ type: T.Type, from url: URL) throws -> T where T: Decodable, T: Sequence, T.Element: Decodable {
        do {
            let data = try Data(contentsOf: url)
            let item = try decode(type, from: data)
            return item
        } catch {
            throw error
        }
    }
}
