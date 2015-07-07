import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:react/react_server.dart' as react_server;

import 'package:isomorphic_dart/src/apis.dart';
import 'package:isomorphic_dart/src/models.dart';
import '../bin/server.dart' as server;

main(){
  String query = 'speed';
  String path = 'search?q=${query}';
  print('Starting benchmark...\n');

  Future request = search(query);
  renderTemplate(path, query, request)
    .then((_)=>exit(0));
}

Future<Iterable<Map>> search(String query){
  print('Testing TMDB search: $query');
  Stopwatch requestStopwatch = new Stopwatch()..start();
  var movieApi = new TmdbMoviesApi(() => new http.IOClient());
  var future = movieApi.search(query);
  future.then((v){
    requestStopwatch.stop();
    print('  finished TmdbMoviesApi.search in ${requestStopwatch.elapsedMilliseconds}ms.');
    //print('$v');
  });
  return future;
}

Future renderTemplate(String path, String query, Future<Iterable<Map>> request) async{
  print('Testing template render:');
  react_server.setServerConfiguration();
  State state = new State(path, {'term': query, 'movies': await request});
  Stopwatch renderStopwatch = new Stopwatch()..start();
  String template = server.renderTemplate(state);
  renderStopwatch.stop();
  print('  finished render in ${renderStopwatch.elapsedMilliseconds}ms.');
  print('\nTemplate:\n');
  print('$template');
}
