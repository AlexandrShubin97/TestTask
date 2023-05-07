//
//  GenerateImageService.swift
//  TestTask
//
//  Created by Александр Шубин on 06.05.2023.
//

import Foundation

enum GenerateImageError: LocalizedError {
    case incorrectURL
    case fetchDataError

    var errorDescription: String? {
        switch self {
        case .incorrectURL:
            return "Некорректная ссылка для генерации изображения"
        case .fetchDataError:
            return "При генерации изображения что-то пошло не так"
        }
    }
}

protocol GenerateImageServiceProtocol {

    /// URL последнего сделанного запроса
    var lastRequestURL: String? { get }

    /// Сгенерировать изображение
    func generateImage(
        by text: String,
        width: Int,
        height: Int,
        completionHandler: @escaping (Result<Data, Error>) -> Void
    )
}

final class GenerateImageService {

    // MARK: - Static properties

    static let shared = GenerateImageService()

    // MARK: - GenerateImageServiceProtocol

    var lastRequestURL: String?

    // MARK: - Initialization

    private init() {}
}

// MARK: - GenerateImageServiceProtocol
extension GenerateImageService: GenerateImageServiceProtocol {

    func generateImage(
        by text: String,
        width: Int,
        height: Int,
        completionHandler: @escaping (Result<Data, Error>) -> Void
    ) {
        guard
            let urlString =
                "https://dummyimage.com/\(width)x\(height)/4f58cc/ffffff&text=\(text)"
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString)
        else {
            completionHandler(.failure(GenerateImageError.incorrectURL))
            return
        }

        lastRequestURL = urlString

        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, _ in
            guard let data = data else {
                completionHandler(.failure(GenerateImageError.fetchDataError))
                return
            }
            completionHandler(.success(data))
        }
        .resume()
    }
}
