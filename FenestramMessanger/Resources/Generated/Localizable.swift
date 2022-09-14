// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum AccountView {
    /// Дата рождения
    internal static let birthday = L10n.tr("Localizable", "account_view.birthday")
    /// Эл. почта
    internal static let email = L10n.tr("Localizable", "account_view.email")
    /// Имя
    internal static let name = L10n.tr("Localizable", "account_view.name")
    /// Никнейм
    internal static let nickname = L10n.tr("Localizable", "account_view.nickname")
    /// Добро пожаловать в FENESTRAM!
    internal static let title = L10n.tr("Localizable", "account_view.title")
  }

  internal enum ChatView {
    /// Здесь будет отображаться список ваших чатов
    internal static let emptyText = L10n.tr("Localizable", "chat_view.empty_text")
    /// %d файлов
    internal static func files(_ p1: Int) -> String {
      return L10n.tr("Localizable", "chat_view.files", p1)
    }
    /// Недавние файлы
    internal static let recentFiles = L10n.tr("Localizable", "chat_view.recent_files")
    /// Изображения
    internal static let recentImage = L10n.tr("Localizable", "chat_view.recent_image")
  }

  internal enum CodeView {
    /// Введите код из СМС
    internal static let enterCode = L10n.tr("Localizable", "code_view.enter_code")
    /// Неверный код
    internal static let incorrectPassword = L10n.tr("Localizable", "code_view.incorrect_password")
    /// Отправить заново?
    internal static let sendAgain = L10n.tr("Localizable", "code_view.send_again")
    /// Отправить заново через %d с
    internal static func sendAgainAfter(_ p1: Int) -> String {
      return L10n.tr("Localizable", "code_view.send_again_after", p1)
    }
  }

  internal enum ContactView {
    /// Добавить контакт
    internal static let addContact = L10n.tr("Localizable", "contact_view.add_contact")
    /// Данного контакта не существует
    internal static let contactDontExist = L10n.tr("Localizable", "contact_view.contact_dont_exist")
    /// Телефонная книга пуста. Хотите добавить контакты?
    internal static let emptyText = L10n.tr("Localizable", "contact_view.empty_text")
    /// %d файлов
    internal static func files(_ p1: Int) -> String {
      return L10n.tr("Localizable", "contact_view.files", p1)
    }
    /// пригласить
    internal static let invateContact = L10n.tr("Localizable", "contact_view.invate_contact")
    /// Контакты
    internal static let title = L10n.tr("Localizable", "contact_view.title")
    /// Пока не зарегистрированы в приложении
    internal static let unregisterContactsTitle = L10n.tr("Localizable", "contact_view.unregister_contacts_title")
    internal enum Search {
      /// Поиск контакта
      internal static let placeholder = L10n.tr("Localizable", "contact_view.search.placeholder")
    }
  }

  internal enum CorrespondenceView {
    /// Файл
    internal static let file = L10n.tr("Localizable", "correspondence_view.file")
    /// Фото
    internal static let foto = L10n.tr("Localizable", "correspondence_view.foto")
    /// Галерея
    internal static let image = L10n.tr("Localizable", "correspondence_view.image")
    /// Здесь будет отображаться история ваших сообщениий
    internal static let message = L10n.tr("Localizable", "correspondence_view.message")
    /// Ваше сообщение
    internal static let textMessage = L10n.tr("Localizable", "correspondence_view.text_message")
  }

  internal enum Error {
    /// Необходимо выбрать фотографию
    internal static let avatarEmpty = L10n.tr("Localizable", "error.avatar_empty")
    /// Необходимо выбрать дату рождения
    internal static let birthdayEmpty = L10n.tr("Localizable", "error.birthday_empty")
    /// Некорректная электронная почта
    internal static let emailIncorrect = L10n.tr("Localizable", "error.email_incorrect")
    /// Имя не может быть пустым
    internal static let nameEmpty = L10n.tr("Localizable", "error.name_empty")
    /// Никнейм не может быть пустым
    internal static let nicknameEmpty = L10n.tr("Localizable", "error.nickname_empty")
    /// Ошибка аутентификационных данных
    internal static let tokenEmpty = L10n.tr("Localizable", "error.token_empty")
    /// Пользователь не существует
    internal static let userDoesNotExist = L10n.tr("Localizable", "error.user_does_not_exist")
  }

  internal enum General {
    /// Отмена
    internal static let cancel = L10n.tr("Localizable", "general.cancel")
    /// Закрыть
    internal static let close = L10n.tr("Localizable", "general.close")
    /// Готово
    internal static let done = L10n.tr("Localizable", "general.done")
    /// Произошла ошибка
    internal static let errorTitle = L10n.tr("Localizable", "general.error_title")
    /// Идет загрузка...
    internal static let loading = L10n.tr("Localizable", "general.loading")
    /// Далее
    internal static let next = L10n.tr("Localizable", "general.next")
    /// Нет соединения с интернетом
    internal static let noInternetConnection = L10n.tr("Localizable", "general.no_internet_connection")
    /// Пропустить
    internal static let skip = L10n.tr("Localizable", "general.skip")
    /// Неизвестно
    internal static let unknown = L10n.tr("Localizable", "general.unknown")
  }

  internal enum MainTabView {
    /// Чат
    internal static let chat = L10n.tr("Localizable", "main_tab_view.chat")
    /// Контакты
    internal static let contacts = L10n.tr("Localizable", "main_tab_view.contacts")
    /// Профиль
    internal static let profile = L10n.tr("Localizable", "main_tab_view.profile")
  }

  internal enum MfMessageComposeView {
    /// Привет, предлагаю тебе присоединиться ко мне в чат Fenestram! Чтобы бы мы всегда оставались на связи.
    internal static let message = L10n.tr("Localizable", "mf_message_compose_view.message")
  }

  internal enum NetworkError {
    internal enum LocalizedError {
      internal enum ErrorDescription {
        /// Нет соединения с интернетом
        internal static let internetError = L10n.tr("Localizable", "network_error.localized_error.error_description.internet_error")
        /// Ой, что-то пошло не так
        internal static let responseError = L10n.tr("Localizable", "network_error.localized_error.error_description.response_error")
        /// Закончилось место
        internal static let runOfSpace = L10n.tr("Localizable", "network_error.localized_error.error_description.run_of_space")
        /// Ошибка сервера. Пожалуйста, попробуйте позже
        internal static let serverError = L10n.tr("Localizable", "network_error.localized_error.error_description.server_error")
        /// Ваша сессия истекла
        internal static let sessionTimedOut = L10n.tr("Localizable", "network_error.localized_error.error_description.session_timed_out")
        /// Пользователь с этим адресом уже существует
        internal static let userAlreadyExists = L10n.tr("Localizable", "network_error.localized_error.error_description.user_already_exists")
      }
      internal enum RecoverySuggestion {
        /// Пожалуйста, проверьте ваше интернет-соединение
        internal static let internetError = L10n.tr("Localizable", "network_error.localized_error.recovery_suggestion.internet_error")
        /// Проверьте правильность вводимых данных
        internal static let responseError = L10n.tr("Localizable", "network_error.localized_error.recovery_suggestion.response_error")
        /// Пожалуйста, освободите место в памяти телефона
        internal static let runOfSpace = L10n.tr("Localizable", "network_error.localized_error.recovery_suggestion.run_of_space")
        /// Сервер недоступен
        internal static let serverError = L10n.tr("Localizable", "network_error.localized_error.recovery_suggestion.server_error")
        /// Не удалось получить новые аутентификационные данные
        internal static let sessionTimedOut = L10n.tr("Localizable", "network_error.localized_error.recovery_suggestion.session_timed_out")
        /// Аккаунт зарегистрирован воспользуйтесь восстановлением пароля
        internal static let userAlreadyExists = L10n.tr("Localizable", "network_error.localized_error.recovery_suggestion.user_already_exists")
      }
    }
  }

  internal enum NewChatView {
    /// Выберите участников чата
    internal static let selectContacts = L10n.tr("Localizable", "new_chat_view.select_contacts")
    /// Создание чата
    internal static let title = L10n.tr("Localizable", "new_chat_view.title")
    internal enum Confirm {
      /// Участники чата
      internal static let contacts = L10n.tr("Localizable", "new_chat_view.confirm.contacts")
      /// Введите имя чата
      internal static let namePlaceholder = L10n.tr("Localizable", "new_chat_view.confirm.name_placeholder")
    }
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
    internal enum Toast {
      /// Не удалось создать контакт
      internal static let failureText = L10n.tr("Localizable", "new_contact_view.toast.failure_text")
      /// Контакт успешно создан
      internal static let successText = L10n.tr("Localizable", "new_contact_view.toast.success_text")
    }
  }

  internal enum OnboardingView {
    /// Разнообразный и богатый опыт рамки и место обучения кадров обеспечивает широкому кругу (специалистов) участие в формировании существенных финансовых и административных условий.
    internal static let firstDescription = L10n.tr("Localizable", "onboarding_view.first_description")
    /// Задача организации, в особенности же рамки и место обучения кадров способствует подготовки и реализации позиций, занимаемых участниками в отношении поставленных задач.
    internal static let secondDescription = L10n.tr("Localizable", "onboarding_view.second_description")
    /// С другой стороны укрепление и развитие структуры играет важную роль в формировании существенных финансовых и административных условий.
    internal static let thirdDescription = L10n.tr("Localizable", "onboarding_view.third_description")
  }

  internal enum PageContactView {
    /// Чат
    internal static let chat = L10n.tr("Localizable", "page_contact_view.chat")
    /// файлов
    internal static let files = L10n.tr("Localizable", "page_contact_view.files")
    /// изображений
    internal static let images = L10n.tr("Localizable", "page_contact_view.images")
    /// участников
    internal static let participants = L10n.tr("Localizable", "page_contact_view.participants")
    /// Участники чата
    internal static let participantsTitle = L10n.tr("Localizable", "page_contact_view.participants_title")
    ///  (вы)
    internal static let you = L10n.tr("Localizable", "page_contact_view.you")
  }

  internal enum PhoneView {
    /// Номер телефона
    internal static let phoneNumber = L10n.tr("Localizable", "phone_view.phone_number")
    /// Отправить код
    internal static let sendCode = L10n.tr("Localizable", "phone_view.send_code")
  }

  internal enum ProfileView {
    /// Дата рождения
    internal static let birthday = L10n.tr("Localizable", "profile_view.birthday")
    /// Эл. почта
    internal static let email = L10n.tr("Localizable", "profile_view.email")
    /// Никнейм
    internal static let nickname = L10n.tr("Localizable", "profile_view.nickname")
    /// Не удалось сохранить профиль
    internal static let saveError = L10n.tr("Localizable", "profile_view.save_error")
    /// Идет сохранение...
    internal static let saveProgress = L10n.tr("Localizable", "profile_view.save_progress")
    /// Профиль успешно сохранен
    internal static let saveSuccess = L10n.tr("Localizable", "profile_view.save_success")
    internal enum SelectPhoto {
      /// Камера
      internal static let camera = L10n.tr("Localizable", "profile_view.select_photo.camera")
      /// Вы можете сделать снимок с камеры, либо выбрать одно фото из галереи телефона
      internal static let message = L10n.tr("Localizable", "profile_view.select_photo.message")
      /// Галерея телефона
      internal static let photoLibrary = L10n.tr("Localizable", "profile_view.select_photo.photo_library")
      /// Выбрать фотографию
      internal static let title = L10n.tr("Localizable", "profile_view.select_photo.title")
    }
  }

  internal enum SettingsView {
    /// Изменить цвет
    internal static let color = L10n.tr("Localizable", "settings_view.color")
    /// Выход из учетной записи
    internal static let exit = L10n.tr("Localizable", "settings_view.exit")
    /// О приложении
    internal static let info = L10n.tr("Localizable", "settings_view.info")
    /// Настройки
    internal static let title = L10n.tr("Localizable", "settings_view.title")
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
