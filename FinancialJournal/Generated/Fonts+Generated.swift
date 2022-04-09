// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit
  import SwiftUI
#endif

// Deprecated typealiases
//@available(*, deprecated, renamed: "FontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
//public typealias Font = FontConvertible.Font

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
public enum Fonts {
  public enum OpenSans {
    public static let bold = FontConvertible(name: "OpenSans-Bold", family: "Open Sans", path: "OpenSans-Bold.ttf")
    public static let italic = FontConvertible(name: "OpenSans-Italic", family: "Open Sans", path: "OpenSans-Italic.ttf")
    public static let light = FontConvertible(name: "OpenSans-Light", family: "Open Sans", path: "OpenSans-Light.ttf")
    public static let regular = FontConvertible(name: "OpenSans-Regular", family: "Open Sans", path: "OpenSans-Regular.ttf")
    public static let semiBold = FontConvertible(name: "OpenSans-SemiBold", family: "Open Sans", path: "OpenSans-SemiBold.ttf")
    public static let all: [FontConvertible] = [bold, italic, light, regular, semiBold]
  }
  public static let allCustomFonts: [FontConvertible] = [OpenSans.all].flatMap { $0 }
  public static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

public extension Font {
  init(uiFont: UIFont) {
    self = Font(uiFont as CTFont)
  }
}

public struct FontConvertible {
  public let name: String
  public let family: String
  public let path: String

  #if os(macOS)
  public typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  //public typealias Font = UIFont
  #endif

  public func font(size: CGFloat) -> Font {
    guard let font = UIFont(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return Font(uiFont: font)
  }

  public func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

public extension UIFont {
  convenience init?(font: FontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(macOS)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
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
