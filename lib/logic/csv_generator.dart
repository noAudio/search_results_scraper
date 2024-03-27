import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as pathp;

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

  Future<String> createSaveFolder() async {
    var docsDirectory = await pathp.getApplicationDocumentsDirectory();

    String folderPath = '${docsDirectory.path}/Google Search Results';

    await Directory(folderPath).create();

    return folderPath;
  }

  Future<void> generate() async {
    String path = await createSaveFolder();
    String csvName =
        '$path/${results[0].searchTerm} - ${fileName.replaceAll('/', '-').replaceAll(':', '.')} - ${site == SiteEnum.baseWebsite ? "Google" : "Google UK"}.csv';
    var file = File(csvName);
    file.writeAsStringSync(
        'Keyword, Date, Sponsored, Website Name, URL, Headline Text, Sub-text\n');

    int listIndex = 0;

    for (var result in results) {
      // break when we get 50 results
      if (listIndex == 50) break;

      file.writeAsStringSync(
        '${result.searchTerm}, ${DateFormat.yMd().add_jm().format(result.dateTime)}, ${result.isSponsored ? "Yes" : "No"}, ${result.website}, ${result.destinationURL}, "${result.headlineText}", "${result.subText}"\n',
        mode: FileMode.append,
      );

      listIndex++;
    }
  }
}
