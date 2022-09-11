//
//  CorrespondenceViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 19.07.2022.
//

import SwiftUI


extension CorrespondenceView {
    @MainActor
    final class ViewModel: ObservableObject, SocketIOManagerObserver {
        
        
        //MARK: - Properties
        
        @Published var textMessage: String = ""
        @Published var isLoading: Bool = false
        @Published var chat: ChatEntity?
        @Published var showSheet: Bool = false
        @Published var showImagePicker: Bool = false
        @Published var messagesWithTime: [Date: [MessageEntity]] = [:]
        @Published var chatImage: UIImage? {
            didSet {
                appendPhoto()
            }
        }
        @Published var presentAlert = false
        @Published var textTitleAlert = ""
        @Published var textAlert = ""
        @Published var allFoto: [PhotoEntity] = []
        
        let contacts: [UserEntity]
        
        private var allMessages: [MessageEntity] = [] {
            didSet {
                processingData()
            }
        }
        
        private var socketManager: SocketIOManager?
        
        private var totalPages = 0
        private(set) var page: Int = 1
        
        private lazy var dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM"
            return dateFormatter
        }()
        
        var lastMessageId: Int?
        var currentMessageId: Int?
        
        init(chat: ChatEntity?, contacts: [UserEntity], socketManager: SocketIOManager?) {
            self.chat = chat
            self.contacts = contacts
            
            if let socketManager = socketManager {
                self.socketManager = socketManager
                socketManager.addObserver(self)
            }
            
            if let chatId = chat?.id {
                getChatUser(id: chatId)
            } else {
                createChat(chatName: contacts.first?.name ?? L10n.General.unknown, usersId: contacts.map({ $0.id }))
            }
        }
        
        func loadMoreContent(currentItem item: MessageEntity){
            let thresholdIndex = self.allMessages.first?.id
            
            if thresholdIndex == item.id, (self.page + 1) <= self.totalPages {
                self.page += 1
                self.getMessages()
            }
        }
        
        func loadMoreContent(){
            if (self.page + 1) <= self.totalPages {
                self.page += 1
                self.getMessages()
            }
        }
        
        
        //MARK: - Query functions
        
        private func getChatUser(id: Int) {
            ChatService.getChat(chatId: id, completion: { [weak self] result in
                switch result {
                case .success(let chat):
                    self?.chat = chat
                    self?.getMessages()
                case .failure(let error):
                    print("get chat user failure with error:", error.localizedDescription)
                    self?.textTitleAlert = "get chat user with error"
                    self?.textAlert = error.localizedDescription
                    self?.presentAlert = true
                }
            })
        }
        
        private func getMessages() {
            guard let chatId = chat?.id else {
                return
            }
            
            isLoading = true
            
            ChatService.getMessages(chatId: chatId, page: page) { [weak self] result in
                switch result {
                case .success(let chatList):
                    self?.totalPages = Int((Float(chatList.total ?? 0) / 10).rounded(.up))
                    print("first element: ", self?.allMessages.first ?? "no element")
                    self?.currentMessageId = self?.allMessages.first?.id
                    var buffer = self?.allMessages ?? []
                    buffer.append(contentsOf: chatList.data ?? [])
                    self?.allMessages = buffer.sorted(by: { $0.id < $1.id })
                    print("Get messages ava:", chatList.data ?? "no data")
                case .failure(let error):
                    print("get messages list failure with error:", error.localizedDescription)
                    self?.textTitleAlert = "get messages list failure with error"
                    self?.textAlert = error.localizedDescription
                    self?.presentAlert = true
                }
                
                self?.isLoading = false
            }
        }
        
        func createChat(chatName: String, usersId: [Int]) {
            isLoading = true
            
            ChatService.createChat(chatName: chatName, usersId: usersId, isGroup: false) { [weak self] result in
                switch result {
                case .success(let chat):
                    print("create chat user success")
                    self?.chat = chat
                    self?.getMessages()
                case .failure(let error):
                    print("create chat user failure with error:", error.localizedDescription)
                    self?.textTitleAlert = "create chat user with error"
                    self?.textAlert = error.localizedDescription
                    self?.presentAlert = true
                }
                
                self?.isLoading = false
            }
        }
        
        func postMessage(chat: ChatEntity?) {
            ChatService.postMessage(chatId: chat?.id ?? 0, messageType: .text, content: textMessage) { [weak self] result in
                switch result {
                case .success(_):
                    self?.textMessage = ""
                case .failure( let error ):
                    print("\(error)")
                }
            }
        }
        
        func getSectionHeader(with date: Date) -> String {
            dateFormatter.string(from: date)
        }
        
        
        //MARK: - Auxiliary functions
        
        private func appendPhoto() {
            guard let foto = chatImage else { return }
            allFoto.append(PhotoEntity(id: allFoto.endIndex, image: foto))
            chatImage = nil
        }
        
        private func processingData() {
            var buffer: [Date: [MessageEntity]] = [:]
            
            allMessages.forEach { message in
                guard let date = message.createdAt else { return }
                let startDate = Calendar.current.startOfDay(for: date)
                
                if buffer[startDate] != nil {
                    buffer[startDate]?.append(message)
                } else {
                    buffer[startDate] = [message]
                }
            }
            
            self.messagesWithTime = buffer
        }
        
        func lastMessage(message: MessageEntity) -> Bool {
            if message.fromUserId == Settings.currentUser?.id {
                return true
            }
            return false
        }
        
        func getUserEntityIds(contactId: Int) -> [Int] {
            var ids: [Int] = []
            ids.append(contactId)
            return ids
        }
        
        func receiveMessage(_ message: MessageEntity) {
            allMessages.append(message)
            processingData()
        }
    }
}

