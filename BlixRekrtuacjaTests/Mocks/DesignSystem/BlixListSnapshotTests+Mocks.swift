import Foundation

extension BlixListSnapshotTests {
    struct Scenario {
        let name: String
        let items: [String]
        let snapshot: SnapshotConfigurator
    }

    nonisolated static let contents: [Scenario] = [
        Scenario(name: "fits", items: Array(cities.prefix(3)), snapshot: .component.layout(.screen)),
        Scenario(name: "overflows", items: cities, snapshot: .component.layout(.screen)),
        Scenario(
            name: "overflows-short-screen",
            items: Array(cities.prefix(15)),
            snapshot: .component.layout(.fixed(width: ShortScreen.width, height: ShortScreen.height))
        )
    ]
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
