

import SwiftUI

struct ResultView: View {
    var movies: [Movie]
    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
            ScrollView{
                LazyVGrid(columns: gridItems, spacing: 20){
                    ForEach(movies, id: \.imdbID) { movie in
                        NavigationLink(destination: DetailView(movie: movie)){
                            MoviePoster(movie: movie)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .navigationTitle("Results")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(movies: [
            Movie(Title: "Avatar", Year: "2009", imdbID: "tt0499549", Poster: "https://example.com/avatar.jpg"),
            Movie(Title: "The Avengers", Year: "2012", imdbID: "tt0848228", Poster: "https://example.com/avengers.jpg")
        ])
        .preferredColorScheme(.dark)
    }
}
