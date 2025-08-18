//
//  JSONLoader.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/18/25.
//

import Foundation
import SwiftUI

// MARK: - Generic JSON decoding helper
enum JSONLoader {
    /// Decode a JSON file from your app bundle.
    static func decode<T: Decodable>(
        _ type: T.Type,
        fromFile name: String,
        withExtension ext: String = "json",
        in bundle: Bundle = .main,
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> T {
        guard let url = bundle.url(forResource: name, withExtension: ext) else {
            throw NSError(domain: "JSONLoader",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Missing \(name).\(ext) in bundle"])
        }
        let data = try Data(contentsOf: url)
        return try decoder.decode(T.self, from: data)
    }

    /// Decode JSON from an arbitrary file URL (e.g., Documents directory).
    static func decode<T: Decodable>(
        _ type: T.Type,
        from url: URL,
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> T {
        let data = try Data(contentsOf: url)
        return try decoder.decode(T.self, from: data)
    }
}

// MARK: - Your model
typealias GratitudeData = [String: [String]]

// MARK: - SwiftUI-friendly store
final class GratitudeStore: ObservableObject {
    @Published var data: GratitudeData = [:]
    @Published var errorMessage: String?

    init(filename: String = "CommonThanksData") {
        loadFromBundle(filename: filename)
    }

    func loadFromBundle(filename: String, ext: String = "json") {
        do {
            data = try JSONLoader.decode(GratitudeData.self, fromFile: filename, withExtension: ext)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// If you save/receive a JSON file elsewhere and want to load it:
    func load(from url: URL) {
        do {
            data = try JSONLoader.decode(GratitudeData.self, from: url)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

