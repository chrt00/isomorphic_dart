part of isomorphic_dart.actions;

Action<State> showSearchResults(String term, Iterable<Movie> movies) {
  return (State state) {
    return new State("/search?q=${Uri.encodeQueryComponent(term)}", {
        "term": term,
        "movies": movies.map((movie) => movie.toJson()).toList()
    });
  };
}

Action<State> showMovie(Movie movie) {
  return (State state) {
    return new State("/movie/${movie.id}", {
        "movie": movie.toJson()
    });
  };
}