import SwiftUI

struct MessageView: View {
    
    var currentMessage: ChatMessage
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            if !currentMessage.isCurrentUser {
                Image("chatgpt-icon")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
            } else {
                Spacer()
            }
            MessageCell(contentMessage: currentMessage.content, isCurrentUser: currentMessage.isCurrentUser)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 10)
        .padding(.trailing, 10)
        .padding(.top, 2.5)
        .padding(.bottom, 2.5)
        .onTapGesture {
            UIPasteboard.general.setValue(currentMessage.content, forPasteboardType: "public.plain-text")
        }
    }
}

#Preview {
    MessageView(currentMessage: ChatMessage(content: "This is a single message cell", isCurrentUser: false))
}
