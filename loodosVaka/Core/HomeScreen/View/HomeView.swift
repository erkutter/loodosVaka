

import SwiftUI

struct HomeView: View {
    private let movieService = MovieService()
    @State private var searchText = ""
    @State private var movies: [Movie] = []
    @State private var isLoading = false
    @State private var isSearching = false
    @State private var isActive: Bool = false
    
    func searchMovies() {
        self.isLoading = true
        self.isSearching = true
        movieService.searchMovies(name: searchText) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let movies):
                    self.movies = movies
                    self.isActive = true
                case .failure:
                    self.movies = []
                }
            }
        }
    }
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack(){
                    Text("Movie Searcher")
                        .fontWeight(.light)
                        .font(.system(size: 30))
                    SearchBar(text: $searchText, onCommit: searchMovies)
                    NavigationLink(destination: ResultView(movies: movies), isActive: $isActive){
                        EmptyView()
                    }
                    .hidden()
                }
                .blur(radius: isLoading ? 3 : 0)
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                        .frame(width: UIScreen.main.bounds.width,
                               height: UIScreen.main.bounds.height)
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: { (isSearching && movies.isEmpty && !isLoading) },
                set: { _ in }
            )) {
                
                        Alert(title: Text("No Movies Found"),
                        message: Text("No movies found for your search."),
                        dismissButton: .default(Text("OK")))
                
            }
        }
        
    }
    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
                .preferredColorScheme(.dark)
        }
    }
}

