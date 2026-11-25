import SwiftUI

extension BlixListSnapshotTests {
    struct Scenario {
        let name: String
        let items: [String]
        let snapshot: SnapshotConfigurator
        var verticalSizeClass = UserInterfaceSizeClass.regular
    }

    nonisolated static let contents: [Scenario] = [
        Scenario(name: "fits", items: Array(cities.prefix(3)), snapshot: .component.layout(.screen)),
        Scenario(name: "overflows", items: cities, snapshot: .component.layout(.screen)),
        Scenario(
            name: "overflows-short-screen",
            items: Array(cities.prefix(15)),
            snapshot: .component.layout(.fixed(width: ShortScreen.width, height: ShortScreen.height))
        ),
        Scenario(
            name: "fits-landscape",
            items: Array(cities.prefix(3)),
            snapshot: .component.layout(.fixed(width: Landscape.width, height: Landscape.height)),
            verticalSizeClass: .compact
        )
    ]
}

/// iPhone 13 turned sideways: the compact height that always scrolls.
private enum Landscape {
    static let width: CGFloat = 844
    static let height: CGFloat = 390
}

private enum ShortScreen {
    static let width: CGFloat = 390
    static let height: CGFloat = 300
}

private let cities = [
    "Warszawa", "Kraków", "Wrocław", "Gdańsk", "Poznań", "Łódź", "Szczecin", "Bydgoszcz", "Lublin", "Białystok",
    "Katowice", "Gdynia", "Częstochowa", "Radom", "Rzeszów", "Toruń", "Sosnowiec", "Kielce", "Gliwice", "Olsztyn",
    "Zabrze", "Bielsko-Biała", "Bytom", "Zielona Góra", "Rybnik", "Ruda Śląska", "Opole", "Tychy",
    "Gorzów Wielkopolski", "Elbląg", "Płock", "Wałbrzych", "Włocławek", "Tarnów", "Chorzów", "Koszalin", "Kalisz",
    "Legnica", "Grudziądz", "Jaworzno", "Słupsk", "Jastrzębie-Zdrój", "Nowy Sącz", "Jelenia Góra", "Siedlce",
    "Mysłowice", "Konin", "Piła", "Piotrków Trybunalski", "Inowrocław"
]
