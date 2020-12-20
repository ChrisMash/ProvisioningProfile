import Foundation

class TestUtils {
    
    enum Error: Swift.Error {
        case fileNotFound
        case incorrectEncoding
    }
    
    static func profile(_ filename: String) throws -> String {
        let bundle = Bundle.module
        guard let url = bundle.url(forResource: filename,
                                   withExtension: "mobileprovision") else {
            throw Error.fileNotFound
        }
        
        let data = try Data(contentsOf: url)
        guard let contents = String(data: data, encoding: .ascii) else {
            throw Error.incorrectEncoding
        }
        
        return contents
    }

    static func expectedDate() -> Date {
        //2021-10-17 14:04:18
        let components = DateComponents(calendar: .current,
                                        timeZone: TimeZone.init(abbreviation: "UTC"),
                                        year: 2021,
                                        month: 10,
                                        day: 17,
                                        hour: 14,
                                        minute: 4,
                                        second: 18)
        return components.date!
    }

    static func expectedDefaultFormattedDate() -> String {
        // simulator by default is set to US locale, so month first
        // also uses 12hr clock
        // also ends up as 3PM as it's BST (ends 31st Oct 2021) rather than GMT/UTC
        //return "10/17/21, 3:04" TODO depends on test device?
        return "17/10/2021, 15:04"
    }
    
}
