// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum ChatView {
    /// Здесь будет отображаться список ваших чатов
    internal static let emptyText = L10n.tr("Localizable", "chat_view.empty_text")
  }

  internal enum General {
    /// Готово
    internal static let done = L10n.tr("Localizable", "general.done")
  }

  internal enum NewContactView {
    /// Добавить контакт
    internal static let title = L10n.tr("Localizable", "new_contact_view.title")
    internal enum LastName {
      /// (необязательно)
      internal static let placeholder = L10n.tr("Localizable", "new_contact_view.last_name.placeholder")
      /// Фамилия
      internal static let title = L10n.tr("Localizable", "new_contact_view.last_name.title")
    }
    internal enum Name {
      /// Не добавлено имя
      internal static let error = L10n.tr("Localizable", "new_contact_view.name.error")
      /// (обязательно)
      internal static let placeholder = L10n.tr("Localizable", "new_contact_view.name.placeholder")
      /// Имя
      internal static let title = L10n.tr("Localizable", "new_contact_view.name.title")
    }
    internal enum PhoneNumber {
      /// Нe добавлен номер телефона
      internal static let emptyError = L10n.tr("Localizable", "new_contact_view.phone_number.empty_error")
      /// Нeкорректный номер телефона
      internal static let incorrectError = L10n.tr("Localizable", "new_contact_view.phone_number.incorrect_error")
      /// +7 _ _ _  _ _ _ - _ _ - _ _
      internal static let placeholder = L10n.tr("Localizable", "new_contact_view.phone_number.placeholder")
      /// Номер телефона
      internal static let title = L10n.tr("Localizable", "new_contact_view.phone_number.title")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
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
