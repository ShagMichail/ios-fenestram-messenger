// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let accentColor = ColorAsset(name: "AccentColor")
  internal static let background = ColorAsset(name: "background")
  internal static let background0 = ColorAsset(name: "background_0")
  internal static let blue1 = ColorAsset(name: "blue_1")
  internal static let blue2 = ColorAsset(name: "blue_2")
  internal static let dark1 = ColorAsset(name: "dark_1")
  internal static let dark2 = ColorAsset(name: "dark_2")
  internal static let green1 = ColorAsset(name: "green_1")
  internal static let grey1 = ColorAsset(name: "grey_1")
  internal static let grey2 = ColorAsset(name: "grey_2")
  internal static let fileCor = ImageAsset(name: "fileCor")
  internal static let fotoCor = ImageAsset(name: "fotoCor")
  internal static let imageCor = ImageAsset(name: "imageCor")
  internal static let onboardingFirst = ImageAsset(name: "onboardingFirst")
  internal static let onboardingSecond = ImageAsset(name: "onboardingSecond")
  internal static let onboardingThird = ImageAsset(name: "onboardingThird")
  internal static let severicons = ImageAsset(name: "Severicons")
  internal static let accessDeniedBanner = ImageAsset(name: "access_denied_banner")
  internal static let accessDeniedTextColor = ColorAsset(name: "access_denied_text_color")
  internal static let addButtonIcon = ImageAsset(name: "add_button_icon")
  internal static let alert = ImageAsset(name: "alert")
  internal static let blueTick = ImageAsset(name: "blue_tick")
  internal static let border = ColorAsset(name: "border")
  internal static let fileButton = ImageAsset(name: "fileButton")
  internal static let imageButton = ImageAsset(name: "imageButton")
  internal static let messageButton = ImageAsset(name: "messageButton")
  internal static let phoneButton = ImageAsset(name: "phoneButton")
  internal static let phoneButtonSmall = ImageAsset(name: "phoneButtonSmall")
  internal static let photoButton = ImageAsset(name: "photoButton")
  internal static let videoButton = ImageAsset(name: "videoButton")
  internal static let videoButtonSmall = ImageAsset(name: "videoButtonSmall")
  internal static let buttonAlert = ColorAsset(name: "buttonAlert")
  internal static let buttonDis = ColorAsset(name: "buttonDis")
  internal static let chatPlaceholderIcon = ImageAsset(name: "chat_placeholder_icon")
  internal static let defaultImage = ImageAsset(name: "defaultImage")
  internal static let deleteAccountIcon = ImageAsset(name: "delete_account_icon")
  internal static let doneButtonBlueIcon = ImageAsset(name: "done_button_blue_icon")
  internal static let doneButtonGreenIcon = ImageAsset(name: "done_button_green_icon")
  internal static let dotsHorizontalIcon = ImageAsset(name: "dots_horizontal_icon")
  internal static let edit = ImageAsset(name: "edit")
  internal static let file = ImageAsset(name: "file")
  internal static let fileText = ColorAsset(name: "fileText")
  internal static let fileWhite = ImageAsset(name: "fileWhite")
  internal static let greenTick = ImageAsset(name: "green_tick")
  internal static let helloMessage = ImageAsset(name: "helloMessage")
  internal static let message = ColorAsset(name: "message")
  internal static let messageIcon = ImageAsset(name: "messageIcon")
  internal static let navBar = ColorAsset(name: "navBar")
  internal static let newContact = ImageAsset(name: "newContact")
  internal static let next = ColorAsset(name: "next")
  internal static let nextButtonBlueIcon = ImageAsset(name: "next_button_blue_icon")
  internal static let nextButtonGreenIcon = ImageAsset(name: "next_button_green_icon")
  internal static let page = ColorAsset(name: "page")
  internal static let phone = ImageAsset(name: "phone")
  internal static let photo = ImageAsset(name: "photo")
  internal static let photoBack = ColorAsset(name: "photoBack")
  internal static let plusIcon = ImageAsset(name: "plus_icon")
  internal static let red = ColorAsset(name: "red")
  internal static let search = ImageAsset(name: "search")
  internal static let send = ImageAsset(name: "send")
  internal static let sendMessageGreen = ImageAsset(name: "send_message_green")
  internal static let sendMessageIc = ImageAsset(name: "send_message_ic")
  internal static let color = ImageAsset(name: "color")
  internal static let exit = ImageAsset(name: "exit")
  internal static let info = ImageAsset(name: "info")
  internal static let stroke = ColorAsset(name: "stroke")
  internal static let tabBar = ColorAsset(name: "tabBar")
  internal static let chat = ImageAsset(name: "chat")
  internal static let chatSelected = ImageAsset(name: "chat_selected")
  internal static let contacts = ImageAsset(name: "contacts")
  internal static let contactsSelected = ImageAsset(name: "contacts_selected")
  internal static let profile = ImageAsset(name: "profile")
  internal static let profileSelected = ImageAsset(name: "profile_selected")
  internal static let text = ColorAsset(name: "text")
  internal static let thema = ColorAsset(name: "thema")
  internal static let video = ImageAsset(name: "video")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
