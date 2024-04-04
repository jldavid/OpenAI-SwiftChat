import SwiftUI

struct MessageCell: View {
    
    var contentMessage: String
    var isCurrentUser: Bool
    let gptColor = Color.init(red: 24/255, green: 149/255, blue: 108/255)
    
    var body: some View {
        Text(contentMessage)
            .padding(10)
            .foregroundColor(isCurrentUser ? Color.white : Color.black)
            .background(isCurrentUser ? gptColor : Color(UIColor.systemGray6))
            .cornerRadius(10)
    }
}

#Preview {
    MessageCell(contentMessage: "This is a message", isCurrentUser: true)
}
