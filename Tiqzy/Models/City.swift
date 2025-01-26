import Foundation

/// Represents major cities in the Netherlands, categorized by their respective regions.
enum City: String, CaseIterable, Hashable {
    case amsterdam = "Amsterdam"
    case rotterdam = "Rotterdam"
    case theHague = "The Hague"
    case utrecht = "Utrecht"
    case eindhoven = "Eindhoven"
    case tilburg = "Tilburg"
    case groningen = "Groningen"
    case almere = "Almere"
    case breda = "Breda"
    case nijmegen = "Nijmegen"
    case enschede = "Enschede"
    case apeldoorn = "Apeldoorn"
    case haarlem = "Haarlem"
    case arnhem = "Arnhem"
    case amersfoort = "Amersfoort"
    case maastricht = "Maastricht"
    case zwolle = "Zwolle"
    case dordrecht = "Dordrecht"
    case leiden = "Leiden"
    case haarlemmermeer = "Haarlemmermeer"
    case denBosch = "Den Bosch"
    case zoetermeer = "Zoetermeer"
    case zwijndrecht = "Zwijndrecht"
    case venlo = "Venlo"
    case alkmaar = "Alkmaar"
    case ede = "Ede"
    case emmen = "Emmen"
    case deventer = "Deventer"
    case bergenOpZoom = "Bergen op Zoom"
    case middelburg = "Middelburg"
    case leeuwarden = "Leeuwarden"
    case hengelo = "Hengelo"
    case veenendaal = "Veenendaal"
    case oss = "Oss"
    case purmerend = "Purmerend"
    case gouda = "Gouda"
    case delft = "Delft"
    case kampen = "Kampen"
    case woerden = "Woerden"
    case roosendaal = "Roosendaal"
    case goes = "Goes"
    case alkmaarZaanstad = "Alkmaar-Zaanstad"
    case sittardGeleen = "Sittard-Geleen"
    case helmond = "Helmond"
    case almelo = "Almelo"
    case assen = "Assen"
    case weert = "Weert"
    case tiel = "Tiel"
    case hoogeveen = "Hoogeveen"
    case sneek = "Sneek"
    case schiedam = "Schiedam"
    case lelystad = "Lelystad"

    /// A human-readable description of the city.
    var description: String {
        self.rawValue
    }

    /// Returns the Dutch province or region where the city is located.
    var region: String {
        switch self {
        case .amsterdam, .haarlemmermeer, .haarlem, .alkmaar, .purmerend:
            return "Noord-Holland"
        case .rotterdam, .theHague, .zoetermeer, .leiden, .delft, .dordrecht, .gouda, .schiedam:
            return "Zuid-Holland"
        case .utrecht, .amersfoort, .veenendaal, .woerden:
            return "Utrecht"
        case .eindhoven, .tilburg, .denBosch, .helmond, .oss, .breda, .bergenOpZoom, .roosendaal:
            return "Noord-Brabant"
        case .groningen:
            return "Groningen"
        case .almere, .lelystad:
            return "Flevoland"
        case .nijmegen, .arnhem, .ede, .apeldoorn, .tiel:
            return "Gelderland"
        case .enschede, .hengelo, .almelo, .zwolle, .kampen, .deventer:
            return "Overijssel"
        case .maastricht, .venlo, .weert, .sittardGeleen:
            return "Limburg"
        case .middelburg, .goes:
            return "Zeeland"
        case .leeuwarden, .assen, .emmen, .hoogeveen, .sneek:
            return "Friesland & Drenthe"
        case .zwijndrecht:
            return "Zuid-Holland" 
        case .alkmaarZaanstad:
            return "Noord-Holland"
        @unknown default:
            return "Unknown Region" // Prevents crashing for unknown cases
        }
    }
}
