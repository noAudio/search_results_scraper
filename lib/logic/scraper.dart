import 'dart:io';

import 'package:puppeteer/puppeteer.dart';
import 'package:search_results/actions/index.dart';
import 'package:search_results/enums/site_enum.dart';
import 'package:search_results/models/search_result.dart';

class Scraper {
  final String _adSelector = 'vdQmEd';
  final String _organicSelector = 'N54PNb';
  final List<SearchResult> searchResults = [];
  final String searchTerm;
  final SiteEnum site;
  final dynamic store;
  late Browser _browser;
  late Page _page;

  Scraper({
    required this.searchTerm,
    required this.site,
    required this.store,
  });

  Future<String> browserPath() async {
    String localPath = './local_chrome';

    if (!Directory(localPath).existsSync()) {
      store
          .dispatch(SetInfoMessageAction(infoMessage: 'Downloading chrome...'));

      var chromeExecutable = await downloadChrome(
        cachePath: localPath,
        onDownloadProgress: (received, total) => store.dispatch(
            SetInfoMessageAction(
                infoMessage:
                    'Downloading chrome (${received ~/ 1000000}/${total ~/ 1000000}MB)')),
      );

      return chromeExecutable.executablePath;
    }

    FileSystemEntity? executablePath;

    try {
      executablePath = Directory(localPath)
          .listSync()
          .firstWhere((file) => file.path.endsWith('chrome.exe'));
    } catch (e) {
      //
    }

    if (executablePath != null) {
      return executablePath.path;
    } else {
      throw Exception('Unable to find the chrome executable!');
    }
  }

  Future<void> launchBrowser() async {
    String link =
        'https://www.google.co${site == SiteEnum.baseWebsite ? "m" : ".uk"}/search?q=${searchTerm.replaceAll(" ", "+")}';

    try {
      String chromePath = await browserPath();
      _browser = await puppeteer.launch(
          headless: false,
          args: ['--start-maximized'],
          executablePath: chromePath);
      _page = await _browser.newPage();
      await _page.goto(link, wait: Until.domContentLoaded);
    } catch (e) {
      store.dispatch(SetErrorMessageAction(errorMessage: e.toString()));
      store.dispatch(SetInfoMessageAction(infoMessage: ''));
    }
  }

  Future<void> closeBrowser() async {
    await _browser.close();
  }

  Future<void> getData() async {
    store.dispatch(SetInfoMessageAction(infoMessage: 'Preparing browser...'));
    await launchBrowser();
    var title = await _page.title;
    print(title);
    // TODO: finish logic
    await closeBrowser();
    store.dispatch(SetInfoMessageAction(
        infoMessage: 'Info downloaded to /path/to/file.csv'));
    store.dispatch(SetInfoMessageAction(infoMessage: ''));
  }
}
