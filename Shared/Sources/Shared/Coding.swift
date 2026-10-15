import Foundation

// The same date format on client and server: ISO 8601 ("2026-10-15T21:00:00Z").
public extension JSONEncoder {
    static var buzz: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}

public extension JSONDecoder {
    static var buzz: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
