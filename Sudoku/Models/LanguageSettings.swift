import Foundation

public enum Language: String {
    case english
    case russian
    
    var code: String {
        switch self {
        case .english: return "en"
        case .russian: return "ru"
        }
    }
}

public final class LanguageSettings: ObservableObject {
    private let languageKey = "selectedLanguage"
    
    @Published public var currentLanguage: Language {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: languageKey)
        }
    }
    
    public var currentLocale: Locale {
        Locale(identifier: currentLanguage.code)
    }
    
    public init() {
        if let saved = UserDefaults.standard.string(forKey: languageKey),
           let lang = Language(rawValue: saved) {
            self.currentLanguage = lang
        } else {
            self.currentLanguage = .english
        }
    }
}
