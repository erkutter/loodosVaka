

import Foundation

struct Constants {
    static let URL = "https://www.omdbapi.com/"
    static let API_KEY = "2e073e73"
}

struct Movie: Codable {
    let Title: String
    let Year: String
    let imdbID: String
    let Poster: String
}


struct MovieResult: Codable {
    let Search: [Movie]
}

struct MovieDetails: Codable {
    let Title: String
    let Year: String
    let Rated: String
    let Released: String
    let Runtime: String
    let Genre: String
    let Director: String
    let Writer: String
    let Actors: String
    let Plot: String
    let Language: String
    let Country: String
    let Awards: String
    let Poster: String
    let Metascore: String
    let imdbRating: String
    let imdbVotes: String
    let imdbID: String
}

struct NotFoundResponse: Codable {
    let Response: String
    let Error: String
}

class MovieService{
    
    func searchMovies(name: String, completion: @escaping(Result<[Movie], Error>) -> Void) {
        guard let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return completion(.failure(URLSessionError.invalidURL))
        }
        
        let urlString = "\(Constants.URL)?s=\(encodedName)&type=movie&apikey=\(Constants.API_KEY)"
        guard let url = URL(string: urlString) else {
            return completion(.failure(URLSessionError.invalidURL))
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let data = data else {
                return completion(.failure(URLSessionError.noData))
            }
            
            do {
               let decoder = JSONDecoder()
               if let errorResponse = try? decoder.decode(NotFoundResponse.self, from: data),
               errorResponse.Response == "False" {
               completion(.failure(MovieSearchError.movieNotFound(errorResponse.Error)))
                } else {
                   let movieResult = try decoder.decode(MovieResult.self, from: data)
                   completion(.success(movieResult.Search))
                        }
                } catch {
                    completion(.failure(error))
                }
        }
        task.resume()
    }
    
    func fetchMovieDetails(imdbID: String, completion: @escaping (Result<MovieDetails, Error>) -> Void) {
           let urlString = "\(Constants.URL)?i=\(imdbID)&apikey=\(Constants.API_KEY)"
           guard let url = URL(string: urlString) else {
               return completion(.failure(URLSessionError.invalidURL))
           }
           
           let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
               if let error = error {
                   return completion(.failure(error))
               }
               
               guard let data = data else {
                   return completion(.failure(URLSessionError.noData))
               }
               
               do {
                   let movieDetails = try JSONDecoder().decode(MovieDetails.self, from: data)
                   completion(.success(movieDetails))
               } catch {
                   completion(.failure(error))
               }
           }
           task.resume()
       }
}


enum URLSessionError: Error {
    case invalidURL
    case noData
}

enum MovieSearchError: Error {
    case movieNotFound(String)
}
