import SwiftUI

enum SFSymbol: String {
    case arrowDown = "arrowtriangle.down.fill"
    case arrowUp = "arrowtriangle.up.fill"
    case chartUptrend = "chart.line.uptrend.xyaxis"
    case checkmark
    case copy = "doc.on.doc"
    case hourglass
    case key
    case minus
    case moon
    case paintbrush
    case wifiSlash = "wifi.slash"
    case xmark

    var image: Image { Image(systemName: rawValue) }
}
