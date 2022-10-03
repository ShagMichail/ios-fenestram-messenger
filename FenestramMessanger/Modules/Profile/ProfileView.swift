//
//  ProfileView.swift
//  TFN
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI
import Combine
import Kingfisher
import AlertToast
import AVFoundation

struct ProfileView: View {
    
    
    //MARK: - Properties
    
    @State private var keyboardHeight: CGFloat = 0
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    @Binding var showTabBar: Bool
    
    @StateObject private var viewModel: ViewModel
    
    init(showTabBar: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: ViewModel())
        _showTabBar = showTabBar
    }
    
    var border: some View {
        RoundedRectangle(cornerRadius: 6)
            .strokeBorder(
                LinearGradient(colors: [Asset.border.swiftUIColor] , startPoint: .topLeading, endPoint: .bottomTrailing))
    }
    
    
    //MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                Asset.background.swiftUIColor
                    .ignoresSafeArea()
                
                VStack {
                    VStack {
                        getHeader()
                    }
                    .padding(.top, 10)
                    
                    if viewModel.isLoading {
                        LoadingView()
                    } else {
                        VStack {
                            getImage()
                            
                            Spacer()
                                .frame(height: 30.0)
                            
                            if viewModel.editProfile {
                                editName()
                            } else {
                                getName()
                                Spacer()
                                    .frame(height: 30.0)
                            }
                            getNicName()
                            getBirthday()
                            getEmail()
                            
                            Spacer()
                                .frame(height: 40.0)
                            if viewModel.editProfile {
                                getButton()
                            }
                        }
                        .padding()
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .padding(.bottom, keyboardHeight/4)
                        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
                        
                        Spacer()
                    }
                }
                if viewModel.presentAlert {
                    AlertView(show: $viewModel.presentAlert, text: viewModel.textAlert)
                }
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .navigationBarHidden(true)
            .toast(isPresenting: $viewModel.showSuccessToast, duration: 1, tapToDismiss: true) {
                AlertToast(displayMode: .alert, type: .complete(isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor), title: L10n.ProfileView.saveSuccess)
            }
            .toast(isPresenting: $viewModel.showErrorToast, duration: 2, tapToDismiss: true) {
                AlertToast(displayMode: .alert, type: .error(Asset.red.swiftUIColor), title: L10n.ProfileView.saveError)
            }
            .toast(isPresenting: $viewModel.showSaveProgressToast, duration: 40, tapToDismiss: false) {
                AlertToast(displayMode: .alert, type: .loading, title: L10n.ProfileView.saveProgress)
            }
        }
    }
    
    
    //MARK: - Views
    
    private func getHeader() -> some View {
        HStack(){
            
            Button {
                if viewModel.editProfile {
                    viewModel.cancelChanges()
                }
                
                viewModel.editProfile.toggle()
            } label: {
                Asset.edit.swiftUIImage
                    .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
            }
            
            Spacer().frame(width: 15)
            
            NavigationLink() {
                SettingsView()
            } label: {
                Image(systemName: "gearshape").foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                    .font(.system(size: 20))
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
            
        }
        .padding(.leading, UIScreen.screenWidth - 90)
    }
    
    private func getAvatar() -> some View {
        VStack {
            if let setImage = viewModel.image {
                Image(uiImage: setImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            } else if let avatarString = viewModel.profile?.avatar,
                      let url = URL(string: Constants.baseNetworkURLClear + avatarString),
                      !avatarString.isEmpty {
                KFImage(url)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            } else {
                Image(uiImage: Asset.photo.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            }
        }
    }
    
    private func getImage() -> some View {
        VStack {
            if viewModel.editProfile {
                Button(action: {
                    viewModel.showSheet = true
                }) {
                    ZStack(alignment: .bottomTrailing) {
                        getAvatar()
                        
                        HStack {
                            Image(systemName: "plus")
                                .font(.title)
                        }
                        .padding(.all, 5.0)
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [(isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor)]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                    }
                }
                .actionSheet(isPresented: $viewModel.showSheet) {
                    ActionSheet(title: Text(L10n.ProfileView.SelectPhoto.title), message: Text(L10n.ProfileView.SelectPhoto.message), buttons: [
                        .default(Text(L10n.ProfileView.SelectPhoto.photoLibrary)) {
                            viewModel.showImagePicker = true
                            self.sourceType = .photoLibrary
                        },
                        .default(Text(L10n.ProfileView.SelectPhoto.camera)) {
                            if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                                viewModel.showImagePicker = true
                                self.sourceType = .camera
                            } else {
                                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) -> Void in
                                    DispatchQueue.main.async {
                                        if granted == true {
                                            viewModel.showImagePicker = true
                                            self.sourceType = .camera
                                        } else {
                                            viewModel.isNeedAccessError = .camera
                                        }
                                    }
                               })
                            }
                        },
                        .cancel()
                    ])
                }
            } else {
                getAvatar()
            }
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(image: $viewModel.image, isShown: $viewModel.showImagePicker, sourceType: self.sourceType)}
        .alert(item: $viewModel.isNeedAccessError, content: { errorType in
            var titleError = L10n.General.errorTitle
            
            switch errorType {
            case .camera:
                titleError = L10n.ProfileView.needAccessToCamera
            }
            
            return Alert(title: Text(titleError),
                         primaryButton: .default(Text(L10n.General.accept), action: {
                       viewModel.openAppSettings()
                   }),
                         secondaryButton: .cancel(Text(L10n.General.cancel)))
        })
    }
    
    private func editName() -> some View {
        VStack(alignment: .leading){
            Text(L10n.AccountView.name)
                .font(.headline)
                .foregroundColor(Asset.text.swiftUIColor)
            Spacer().frame(height: 3.0)
            
            ZStack {
                HStack (spacing: 5){
                    TextField("", text: $viewModel.name) { (status) in
                        if status {
                            viewModel.isTappedName = true
                        } else {
                            viewModel.isTappedName = false
                        }
                    } onCommit: {
                        viewModel.isTappedName = false
                    }
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 12)
                    .padding(.leading, 10)
                    .padding(.trailing, 5)
                    .foregroundColor(Asset.text.swiftUIColor)
                    .multilineTextAlignment(.leading)
                    .accentColor(Asset.text.swiftUIColor)
                    .keyboardType(.default)
                    .textContentType(.name)
                    .onReceive(Just(viewModel.name)) { _ in
                        viewModel.limitNameText(20)
                    }
                }
            }.background(border)
        }
    }
    
    private func getName() -> some View {
        VStack(alignment: .center) {
            Text(viewModel.name)
                .font(FontFamily.Poppins.bold.swiftUIFont(size: 22))
                .foregroundColor(Color.white)
                .bold()
            Spacer().frame(height: 3.0 )
        }
    }
    
    private func getNicName() -> some View {
        VStack(alignment: .leading){
            Text(L10n.ProfileView.nickname)
                .font(.headline)
                .foregroundColor(Asset.text.swiftUIColor)
            Spacer().frame(height: 3.0 )
            ZStack {
                HStack (spacing: 5) {
                    TextField("", text: $viewModel.nicName) { (status) in
                        if status {
                            viewModel.isTappedNicName = true
                        } else {
                            viewModel.isTappedNicName = false
                        }
                    } onCommit: {
                        viewModel.isTappedNicName = false
                    }
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 12)
                    .padding(.leading, 10)
                    .padding(.trailing, 5)
                    .foregroundColor(Asset.text.swiftUIColor)
                    .multilineTextAlignment(.leading)
                    .accentColor(Asset.text.swiftUIColor)
                    .keyboardType(.default)
                    .disabled(!viewModel.editProfile)
                    .onReceive(Just(viewModel.nicName)) { _ in
                        viewModel.limitNicNameText(20)
                    }
                }
            }.background(border)
        }
    }
    
    private func getBirthday() -> some View {
        VStack(alignment: .leading){
            Text(L10n.ProfileView.birthday)
                .font(.headline)
                .foregroundColor(Asset.text.swiftUIColor)
            
            Spacer().frame(height: 3.0 )
            
            ZStack {
                HStack (spacing: 5) {
                    DatePickerTextField(placeholder: "", date: $viewModel.birthday)
                        .padding(.vertical, 12)
                        .padding(.leading, 10)
                        .padding(.trailing, 5)
                        .frame( height: 46.0)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 20))
                        .disabled(!viewModel.editProfile)
                }
            }.background(border)
        }
    }
    
    private func getEmail() -> some View {
        VStack(alignment: .leading){
            Text(L10n.ProfileView.email)
                .font(.headline)
                .foregroundColor(Asset.text.swiftUIColor)
            
            Spacer().frame(height: 3.0)
            
            ZStack {
                HStack (spacing: 5) {
                    TextField("", text: $viewModel.textEmail) { (status) in
                        if status {
                            viewModel.isTappedEmail = true
                        } else {
                            viewModel.isTappedEmail = false
                        }; onCommit: do {
                            
                            if viewModel.textFieldValidatorEmail(viewModel.textEmail) {
                                viewModel.isEmailValid = true
                                viewModel.textEmailOk = true
                            } else {
                                viewModel.isEmailValid = false
                                viewModel.textEmailOk = false
                                
                            }
                        }
                    }
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 12)
                    .padding(.leading, 10)
                    .padding(.trailing, 5)
                    .foregroundColor(Asset.text.swiftUIColor)
                    .multilineTextAlignment(.leading)
                    .accentColor(Asset.text.swiftUIColor)
                    .keyboardType(.emailAddress)
                    .ignoresSafeArea(.keyboard)
                    .disabled(!viewModel.editProfile)
                }
            }.background(border)
        }
    }
    
    private func getButton() -> some View {
        HStack {
            Button(action: {
                viewModel.cancelChanges()
                viewModel.editProfile.toggle()
            }) {
                Text(L10n.General.cancel)
                    .frame(width: UIScreen.screenWidth/2 - 30, height: 45.0)
                    .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 16))
                    .foregroundColor(Asset.text.swiftUIColor)
                    .background(Asset.navBar.swiftUIColor)
                    .cornerRadius(6)
            }
            
            Spacer()
            
            Button(action: {
                viewModel.saveInfo()
            }) {
                Text(L10n.General.done)
                    .frame(width: UIScreen.screenWidth/2 - 30, height: 45.0)
                    .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 16))
                    .foregroundColor(.white)
                    .background(isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor)
                    .cornerRadius(6)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(showTabBar: .constant(true))
    }
}
