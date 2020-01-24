//
//  MovieController.swift
//  MoveSearch31
//
//  Created by Jon Corn on 1/24/20.
//  Copyright © 2020 jdcorn. All rights reserved.
//

import UIKit

class MovieController {
    
    // MARK: - String Helpers
    // Components for base movie search URL
    static private let movieBaseURL = URL(string: "https://api.themoviedb.org/3")
    static private let searchComponent = "search"
    static private let movieComponent = "movie"
    
    // Components for movie poster image URL
    static private let imageBaseURL = URL(string: "https://image.tmdb.org/t/p")
    static private let imageSizeComponent = "w500"
    
    // Query item name and values
    static private let APIKeyQueryName = "api_key"
    static private let APIKeyQueryValue = "1c22df5949de6e4243d3f54553ddfbf1"
    static private let languageQueryName = "language"
    static private let languageQueryValue = "en-US"
    static private let searchQueryName = "query"
    
    // MARK: - Methods
    static func getMovies(searchTerm: String, completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        //  Build URL
        guard let baseURL = movieBaseURL else { return completion(.failure(.invalidURL))}
        let searchURL = baseURL.appendingPathComponent(searchComponent)
        let movieURL = searchURL.appendingPathComponent(movieComponent)
        //  Add query items
        var components = URLComponents(url: movieURL, resolvingAgainstBaseURL: true)
        let APIQuery = URLQueryItem(name: APIKeyQueryName, value: APIKeyQueryValue)
        let langQuery = URLQueryItem(name: languageQueryName, value: languageQueryValue)
        let searchQuery = URLQueryItem(name: searchQueryName, value: searchTerm)
        components?.queryItems = [APIQuery, langQuery, searchQuery]
        //  Final URL
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
        print(finalURL)
        //  DataTask
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            //  Handle error
            if let error = error {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            //  Unwrap data
            guard let data = data else { return completion(.failure(.noDataFound))}
            //  Decode
            do {
                let decoder = JSONDecoder()
                let TopLevelObject = try decoder.decode(TopLevelDict.self, from: data)
                let movie = TopLevelObject.results
                return completion(.success(movie))
            } catch {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func getImage(movie: Movie, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        //  Make sure there's a poster before continuing
        guard let moviePoster = movie.poster else { return completion(.failure(.noPosterFound))}
        //  Build poster URL
        guard let baseURL = imageBaseURL else { return completion(.failure(.invalidURL))}
        let imageSizeURL = baseURL.appendingPathComponent(imageSizeComponent)
        let finalURL = imageSizeURL.appendingPathComponent(moviePoster)
        print(finalURL)
        //  DataTask
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            //  Unwrap data
            guard let data = data else { return completion(.failure(.noDataFound))}
            //  Apple decodes images for us
            guard let image = UIImage(data: data) else { return completion(.failure(.noPosterFound))}
            return completion(.success(image))
        }.resume()
    }
}
