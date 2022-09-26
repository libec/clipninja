import Foundation
import XCTest

extension XCTestCase {

    enum LoadJsonForTestError: Error {
        case invalidUrl
    }

    func loadFromJson<T: Decodable>(type: T.Type, path: String) throws -> T {
        guard let url = Bundle.module.url(forResource: path, withExtension: "json") else {
            throw LoadJsonForTestError.invalidUrl
        }

        let data = try Data(contentsOf: url, options: [])
        return try JSONDecoder().decode(type, from: data)
    }
}

