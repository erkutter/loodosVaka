//
//  MoviePoster.swift
//  loodosVaka
//
//  Created by Erkut Ter on 18.06.2023.
//

import SwiftUI

struct MoviePoster: View {
    let movie: Movie
    
    var body: some View {
        VStack{
            AsyncImage(url: URL(string: movie.Poster)) { phase in
                switch phase {
                case    .empty:
                    ProgressView()
                case    .success(let image):
                    image.resizable()
                case .failure:
                    Image(systemName: "photo")
                @unknown default:
                    ProgressView()
                }
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: 150, height: 200)
            Text(movie.Title)
                .fontWeight(.regular)
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
        }
            .padding()
    }
}

struct MoviePoster_Previews: PreviewProvider {
    static var previews: some View {
        MoviePoster(movie: Movie(Title: "Avatar", Year: "2009", imdbID: "tt0499549", Poster: "https://m.media-amazon.com/images/M/MV5BOTNkMzNlNmQtMWRlYS00MTExLWExNjgtODc0MGRjNjE1OGQwXkEyXkFqcGdeQXVyMjAwNzczNTU@._V1_SX300.jpg"))
    }
}
