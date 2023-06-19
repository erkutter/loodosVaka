//
//  DetailView.swift
//  loodosVaka
//
//  Created by Erkut Ter on 18.06.2023.
//

import SwiftUI
import FirebaseAnalytics

struct DetailView: View {
    let movie: Movie
    @State private var movieDetails: MovieDetails?
    @State private var isLoading = false
    private let movieService = MovieService()
    
     private func fetchMovieDetails(){
         isLoading = true
         movieService.fetchMovieDetails(imdbID: movie.imdbID) { result in
         isLoading = false
             switch result{
                 case .success(let details):
                 movieDetails = details
                 case .failure(let error):
                 print(error)
             }
         }
     }
    
    func logMovieViewEvent(movie:Movie){
        Analytics.logEvent(AnalyticsEventSelectContent, parameters:[
            AnalyticsParameterItemID: movie.imdbID,
            AnalyticsParameterItemName: movie.Title,
        ])
    }
   
    
    var body: some View {
        Group{
             if let movieDetails = movieDetails {
            ScrollView {
                VStack {
                    AsyncImage(url: URL(string: movieDetails.Poster)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width,
                                       height: 450)
                            Text(movieDetails.Title).font(.title).fontWeight(.bold)
                            Text("Year: " + movieDetails.Year).bold()
                            Text("Rating: " + movieDetails.imdbRating).bold()
                            VStack(alignment: .leading){
                                Text("Runtime: " + movieDetails.Runtime)
                                    .padding(.vertical,5)
                                Text("Actors: " + movieDetails.Actors)
                                    .padding(.vertical,5)
                                Text("Description: " + movieDetails.Plot)
                            }
                            .font(.system(size: 20))
                            .padding(5)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                        @unknown default:
                            ProgressView()
                        }
                    }
                }
            }
               } else if isLoading{
                   ProgressView()
               } else {
                 Text("Failed to load movie details")
               }
            }
        
            .onAppear(){
                fetchMovieDetails()
                logMovieViewEvent(movie: movie)
            }
            .navigationBarTitle(Text(movie.Title), displayMode: .inline)
            .ignoresSafeArea()
            .padding()
        }
    }
    
    struct DetailView_Previews: PreviewProvider {
        static var previews: some View {
            DetailView(movie: Movie(Title: "Avatar", Year: "2009", imdbID: "tt0499549", Poster: "https://m.media-amazon.com/images/M/MV5BMjAyMDIyNzA4NV5BMl5BanBnXkFtZTgwMDgxNzE0ODE@._V1_SX300.jpg"))
                .preferredColorScheme(.dark)
        }
    }


