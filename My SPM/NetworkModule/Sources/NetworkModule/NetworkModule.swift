// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

public class APIService {
    private let apiKey = "6644ab88296d45c8947fb7eab9bbe523"
    private var page = 1
    private let pageSize = 10

    public init() {}

    public func fetchNews(query: String, completion: @escaping (Result<[News], Error>) -> Void) {
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=\(query)&page=\(page)&pageSize=\(pageSize)&sortBy=publishedAt&apiKey=\(apiKey)") else {
            completion(.failure(APIServiceError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(APIServiceError.noData))
                return
            }

            do {
                let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                completion(.success(newsResponse.articles))
                self?.page += 1
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
