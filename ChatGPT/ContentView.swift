import SwiftUI
import Alamofire
import Combine

struct ContentView: View {
    
    @State var messages = [ChatMessage]()
    @State var userPrompt: String = ""
    let gptColor = Color.init(red: 24/255, green: 149/255, blue: 108/255)

    var body: some View {
        VStack {
            Spacer()
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(messages, id: \.self) { message in
                            MessageView(currentMessage: message)
                                .id(message)
                        }
                    }
                    .onReceive(Just(messages)) { _ in
                        withAnimation {
                            proxy.scrollTo(messages.last, anchor: .bottom)
                        }
                    }.onAppear {
                        withAnimation {
                            messages.append(ChatMessage(content: NSLocalizedString("hello", comment: "Welcome to ChatGPT!"), isCurrentUser: false))
                            proxy.scrollTo(messages.last, anchor: .bottom)
                        }
                    }
                }
                HStack {
                    TextField("Send a prompt", text: $userPrompt)
                        .textFieldStyle(.roundedBorder)
                    Button(action: sendPrompt) {
                        Image(systemName: "paperplane")
                            .tint(gptColor)
                    }
                }            }
        }
    }
    
    func sendPrompt() {
        if !userPrompt.isEmpty {
            messages.append(ChatMessage(content: userPrompt, isCurrentUser: true))
            Task {
                await requestChatGptResponse(prompt: userPrompt)
            }
        }
    }
    
    func requestChatGptResponse(prompt: String) async {
        let apiKey = "ADD_YOUR_OPENAPI_KEY"
        let openAIURL = "https://api.openai.com/v1/chat/completions"
        let bearerToken = "Bearer \(apiKey)"
        let body = "{\"model\":\"gpt-3.5-turbo\",\"messages\":[{\"role\":\"user\",\"content\":\"\(prompt)\"}],\"temperature\":1,\"max_tokens\":256,\"top_p\":1,\"frequency_penalty\":0,\"presence_penalty\":0}"
        let data =  body.data(using: .utf8)
        if let url = URL(string: openAIURL) {
            var urlRequest = URLRequest(url: url)
            urlRequest.method = .post
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue(bearerToken, forHTTPHeaderField: "Authorization")
            urlRequest.httpBody = data
            
            let request = AF.request(urlRequest)
            request.responseDecodable(of: chatGptResponse.self) { response in
                switch response.result {
                case .success(let chatResponse):
                    //dump(chatResponse)
                    messages.append(ChatMessage(content: chatResponse.choices[0].message.content, isCurrentUser: false))
                    userPrompt = ""
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}
