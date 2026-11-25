import SwiftUI

enum SFSymbol: String {
    case checkmark
    case moon
    case paintbrush
    case wifiSlash = "wifi.slash"

    var image: Image { Image(systemName: rawValue) }
}
