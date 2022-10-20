//
//  CorrespondenceViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 19.07.2022.
//

import SwiftUI

enum CorrespondenceBottomSheetPosition: CGFloat, CaseIterable {
    case bottom = 220, hidden = 0
}

enum EditingMessageBottomSheetPosition: CGFloat, CaseIterable {
    case bottom = 220, hidden = 0
}

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
        
        @Published var showUploadImageErrorToast: Bool = false
        @Published var showUploadImageProgressToast: Bool = false
        var successUploadImageMessage: String = L10n.CorrespondenceView.Toast.UploadImage.fullSuccess
        @Published var showUploadImageSuccessToast: Bool = false
        
        @Published var selectedImage: Image?
        @Published var selectedMessage: MessageEntity?
        
        @Published var deleteMessageForMeOrEveryone: DeleteMessageFor = .me {
            willSet {
                deleteMessage(newValue)
            }
        }
        
        @Published var showAlertError: Bool = false
        var showAlertErrorText: String = ""
        
        var selectedImageURL: URL?
        
        let contacts: [ContactEntity]
        
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
            dateFormatter.dateFormat = "d MMMM"
            return dateFormatter
        }()
        
        private var loadMoreDispatchWorkItem: DispatchWorkItem?
        private var stopLoadMoreCount: Int = 0
        
        var lastMessageId: Int?
        var currentMessageId: Int?
        
        init(chat: ChatEntity?, contacts: [ContactEntity], socketManager: SocketIOManager?) {
            self.chat = chat
            self.contacts = contacts
            
            if let socketManager = socketManager {
                self.socketManager = socketManager
                socketManager.checkConnect()
                socketManager.addObserver(self)
            }
            
            if let chatId = chat?.id {
                getChatUser(id: chatId)
            } else {
                createChat(chatName: contacts.first?.name ?? L10n.General.unknown, usersId: contacts.map({ $0.id }))
            }
        }
        
        func loadMoreContent(currentItem item: MessageEntity) {
            let thresholdIndex = self.allMessages.first?.id
            
            if thresholdIndex == item.id, (self.page + 1) <= self.totalPages {
                self.stopLoadMoreCount = 0
                
                loadMoreDispatchWorkItem = DispatchWorkItem(block: { [weak self] in
                    guard let self = self else { return }
                    
                    self.page += 1
                    self.getMessages()
                })
                
                if let loadMoreDispatchWorkItem = loadMoreDispatchWorkItem {
                    self.isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: loadMoreDispatchWorkItem)
                }
            } else {
                if let loadMoreDispatchWorkItem = loadMoreDispatchWorkItem, stopLoadMoreCount > 0 {
                    loadMoreDispatchWorkItem.cancel()
                    self.loadMoreDispatchWorkItem = nil
                    self.isLoading = false
                } else {
                    stopLoadMoreCount += 1
                }
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
            
            ChatService.getMessages(chatId: chatId, page: page, limit: 10) { [weak self] result in
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
        
        func postTextMessage() {
            guard let chatId = chat?.id else { return }
            
            ChatService.postMessage(chatId: chatId, messageType: .text, content: textMessage) { [weak self] result in
                switch result {
                case .success(_):
                    self?.textMessage = ""
                case .failure( let error ):
                    print("\(error)")
                }
            }
        }
        
        func postImageMessage() {
            guard let chatId = chat?.id else { return }
            
            guard allFoto.count > 0 else {
                return
            }
            
            let dispatchGroup: DispatchGroup = DispatchGroup()
            var successSendCount: Int = 0
            
            showUploadImageProgressToast = true
            
            allFoto.forEach { photo in
                dispatchGroup.enter()
                
                uploadFile(image: photo.image) { urlString, error in
                    if let error = error {
                        print("load image failure with error: ", error)
                        dispatchGroup.leave()
                    } else if let urlString = urlString {
                        print("load image success")
                        
                        ChatService.postMessage(chatId: chatId, messageType: .image, content: urlString) { result in
                            switch result {
                            case .success:
                                print("send image message success")
                                successSendCount += 1
                            case .failure(let error):
                                print("send image message failure with error: ", error)
                            }
                            
                            dispatchGroup.leave()
                        }
                    } else {
                        #if DEBUG
                        fatalError("something wrong")
                        #else
                        print("something wrong")
                        #endif
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) { [weak self] in
                guard let self = self else { return }
                
                self.showUploadImageProgressToast = false
                
                if successSendCount == 0 {
                    self.showUploadImageErrorToast = true
                } else if self.allFoto.count != successSendCount {
                    self.successUploadImageMessage = L10n.CorrespondenceView.Toast.UploadImage.partSuccess(successSendCount, self.allFoto.count)
                    self.showUploadImageSuccessToast = true
                    self.allFoto.removeAll()
                } else {
                    self.successUploadImageMessage = L10n.CorrespondenceView.Toast.UploadImage.fullSuccess
                    self.showUploadImageSuccessToast = true
                    self.allFoto.removeAll()
                }
            }
        }
        
        func getSectionHeader(with date: Date) -> String {
            dateFormatter.string(from: date)
        }
        
        private func deleteMessage(_ deleteForAll: DeleteMessageFor) {
            if let selectMess = selectedMessage, let chatId = chat?.id {
                
                var fromAll: Bool = false
                switch deleteForAll {
                case .all:
                    fromAll = true
                case .me:
                    fromAll = false
                }
                presentAlert = false

                ChatService.deleteMessage(chatId: chatId, messagesId: [selectMess.id], fromAll: fromAll) { [weak self] result in
                    switch result {
                    case .success(_):
                        self?.allMessages = self?.allMessages.filter { $0 != selectMess } ?? []
                        self?.processingData()
                    case .failure(let error):
                        print("error", error)
                        self?.showAlertError = true
                        self?.showAlertErrorText = L10n.CorrespondenceView.errorDeleteMessage
                    }
                }
            }
        }
        
        func editMessage() {
            if let selectMess = selectedMessage, let chatId = chat?.id {
                ChatService.editMessage(chatId: chatId, messagesId: selectMess.id, text: textMessage) { [weak self] result in
                    switch result {
                    case .success(_):
                        self?.allMessages = self?.allMessages.filter { $0 != selectMess } ?? []
                        self?.processingData()
                    case .failure(let error):
                        print("error", error)
                        self?.showAlertError = true
                        self?.showAlertErrorText = L10n.CorrespondenceView.errorDeleteMessage
                    }
                }
            }
        }
        
        //MARK: - Auxiliary functions
        
        private func uploadFile(image: UIImage, completion: @escaping (String?, Error?) -> ()) {
            if let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
               let jpegData = image.jpegData(compressionQuality: 1.0) {
                
                let fileName = "image_\(image.hashValue).jpeg"
                let url = documents.appendingPathComponent(fileName)
                
                do {
                    try jpegData.write(to: url)
                    upload(imagePathURL: url, completion: completion)
                }
                catch let error {
                    print("error: ", error.localizedDescription)
                    completion(nil, error)
                }
            }
        }
        
        private func upload(imagePathURL: URL, completion: @escaping (String?, Error?) -> ()) {
            FilesService.upload(imageURL: imagePathURL) { result in
                switch result {
                case .success(let fileData):
                    print("JSON: ", fileData)
                    
                    completion(fileData.pathToFile, nil)
                    
                    do {
                        try FileManager.default.removeItem(at: imagePathURL)
                    }
                    catch let error {
                        print("error: ", error.localizedDescription)
                        completion(nil, error)
                    }
                    
                case .failure(let error):
                    print("error: ", error.localizedDescription)
                    completion(nil, error)
                }
            }
        }
        
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
        
        func isMessageFromCurrentUser(message: MessageEntity) -> Bool {
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
            guard let chatId = chat?.id,
                  let messageChatId = message.chatId,
                  chatId == messageChatId else { return }
            
            if !allMessages.contains(where: { $0 == message }) {
                allMessages.append(message)
            }
            
            processingData()
        }
        
        func copyToClipBoard() {
            guard let selectedMessage = selectedMessage else { return }
            UIPasteboard.general.string =   ""
            UIPasteboard.general.string = selectedMessage.message
        }
        
        func checkSelectedMessageIsMine() -> Bool {
            guard let selectedMessage = selectedMessage else { return false }
            return selectedMessage.fromUserId == Settings.currentUser?.id
        }
        
        func checkEditingMessage() -> Bool {
            /// проверка на возможность редактирования сообщения ( > 24 часов )
            guard let selectedMessage = selectedMessage else { return false }
            if let createdDate = selectedMessage.createdAt,
               let dateDiff = Calendar.current.dateComponents([.hour], from: createdDate, to: Date()).hour {
                return dateDiff < 24
            } else {
                return false
            }
        }
    }
}

