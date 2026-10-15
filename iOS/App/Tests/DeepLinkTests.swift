import Foundation
import Testing

@testable import Buzz

@Test(
    "Deep links are parsed",
    arguments: [
        ("buzz://add", DeepLink.add),
        ("buzz://stats", DeepLink.stats),
    ]
)
func parse(url: String, expected: DeepLink) {
    #expect(DeepLink(url: URL(string: url)!) == expected)
}

@Test("Unknown links are ignored", arguments: ["buzz://nope", "https://add"])
func ignore(url: String) {
    #expect(DeepLink(url: URL(string: url)!) == nil)
}
