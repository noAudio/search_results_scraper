import 'dart:io';

import 'package:search_results/models/search_result.dart';

class CSVGenerator {
  final String fileName;
  final List<SearchResult> results;

  CSVGenerator({required this.fileName, required this.results});

  void generate() {
    // TODO: Save to Documents directory
    var file = File('$fileName.csv');
    file.writeAsStringSync(
        'Keyword, Date, Sponsored, Website Name, URL, Headline Text, Sub-text\n');

    for (var result in results) {
      if (results.indexOf(result) == 50) {
        // break when we get 50 results
        break;
      }
      // TODO: Format date
      file.writeAsStringSync(
        '${result.searchTerm}, ${result.dateTime}, ${result.isSponsored ? "Yes" : "No"}, ${result.website}, ${result.destinationURL}, "${result.headlineText}", ${result.subText}\n',
        mode: FileMode.append,
      );
    }
  }
}
