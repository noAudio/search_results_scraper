import 'dart:io';

import 'package:intl/intl.dart';
import 'package:search_results/enums/site_enum.dart';
import 'package:search_results/models/search_result.dart';

class CSVGenerator {
  final String fileName;
  final List<SearchResult> results;
  final SiteEnum site;

  CSVGenerator({
    required this.fileName,
    required this.results,
    required this.site,
  });

  void generate() {
    // TODO: Save to Documents directory
    var file = File(
        '${results[0].searchTerm} - $fileName - ${site == SiteEnum.baseWebsite ? "Google" : "Google UK"}.csv');
    file.writeAsStringSync(
        'Keyword, Date, Sponsored, Website Name, URL, Headline Text, Sub-text\n');

    int listIndex = 0;

    for (var result in results) {
      // break when we get 50 results
      if (listIndex == 50) break;

      file.writeAsStringSync(
        '${result.searchTerm}, ${DateFormat.yMd().add_jm().format(result.dateTime)}, ${result.isSponsored ? "Yes" : "No"}, ${result.website}, ${result.destinationURL}, "${result.headlineText}", ${result.subText}\n',
        mode: FileMode.append,
      );

      listIndex++;
    }
  }
}
