import SwiftUI
import Foundation

struct chatGptResponse: Codable {
    var id: String
    var object: String
    var created: Int
    var model: String
    var choices: [Choice]
    var usage: Usage
    var system_fingerprint: String
}

struct Choice: Codable, Identifiable {
    var id: Int { index }
    var index: Int
    var message: Message
    var logprobs: Double?
    var finish_reason: String
}

struct Message: Codable {
    var role: String
    var content: String
}

struct Usage: Codable {
    var prompt_tokens: Int
    var completion_tokens: Int
    var total_tokens: Int
}

struct ChatMessage: Hashable {
    var id = UUID()
    var content: String
    var isCurrentUser: Bool
}
