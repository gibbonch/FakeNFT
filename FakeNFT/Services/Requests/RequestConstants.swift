import Foundation

enum RequestConstants {
    static let baseURL = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net"
    
    #warning("Instert your token here")
    static var token: String? {
        guard let fileURL = Bundle.main.path(forResource: "Token", ofType: "txt") else {
            assertionFailure("Файл Token.txt не найден в корне проекта")
            return nil
        }
        
        do {
            let token = try String(contentsOfFile: fileURL, encoding: .utf8)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            return token
        } catch {
            assertionFailure("Ошибка чтения файла Token.txt: \(error)")
            return nil
        }
    }
}
