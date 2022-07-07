//
//  FileManager.swift
//  Wordlist-Game
//
//  Created by Alexander Khitev on 7/7/22.
//

import Foundation

extension FileManager {
    func copyFileToDocsFolder(_ sourceURL: URL) throws -> URL {
        let url = urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = url.appendingPathComponent(sourceURL.lastPathComponent)
            .appendingPathExtension(url.pathExtension)
        if fileExists(atPath: destinationURL.path) {
            try removeItem(at: destinationURL)
        }
        try copyItem(at: sourceURL, to: destinationURL)
        return destinationURL
    }
}
