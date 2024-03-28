import 'dart:io';

import 'package:puppeteer/puppeteer.dart';
import 'package:search_results/actions/index.dart';
import 'package:search_results/enums/site_enum.dart';
import 'package:search_results/models/search_result.dart';

class Scraper {
  final String _adSelector = '.vdQmEd';
  final String _organicSelector = '.N54PNb';
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
          .listSync(recursive: true, followLinks: false)
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

  Future<int> checkResults() async {
    var organicResults = await _page.$$(_organicSelector);
    var adResults = await _page.$$(_adSelector);

    return organicResults.length + adResults.length;
  }

  Future<String> getTextContent(
      ElementHandle elementHandle, String selector) async {
    var element = await elementHandle.$(selector);
    return await element.evaluate('element => element.textContent');
  }

  Future<void> extractResultInfo(
      List<ElementHandle> organicResults, List<ElementHandle> adResults) async {
    for (var adResult in adResults) {
      String websiteName = await getTextContent(adResult, '.TElO2c>span');
      var linkElement = await adResult.$('a.sVXRqc');
      var href = await linkElement.property('href');
      String fullURL = href.toString().split('JSHandle:')[1];
      String headlineText = await getTextContent(adResult, '.EE3Upf>span');
      String subText = await getTextContent(adResult, '.lVm3ye>div');

      // Check if date is present then remove
      if (subText.contains('— ')) {
        subText = subText.split('— ')[1];
      }

      searchResults.add(
        SearchResult(
          searchTerm: searchTerm,
          dateTime: DateTime.now(),
          isSponsored: true,
          website: websiteName,
          destinationURL: fullURL,
          headlineText: headlineText,
          subText: subText,
        ),
      );
    }

    for (var organicResult in organicResults) {
      String websiteName = await getTextContent(organicResult, '.CA5RN>span');
      var linkElement = await organicResult.$('.yuRUbf>div>span>a');
      var href = await linkElement.property('href');
      String fullURL = href.toString().split('JSHandle:')[1];
      String headlineText = await getTextContent(organicResult, '.DKV0Md');
      String subText = await getTextContent(organicResult, '.Hdw6tb');

      // Check if date is present then remove
      if (subText.contains('— ')) {
        subText = subText.split('— ')[1];
      }

      searchResults.add(
        SearchResult(
          searchTerm: searchTerm,
          dateTime: DateTime.now(),
          isSponsored: false,
          website: websiteName,
          destinationURL: fullURL,
          headlineText: headlineText,
          subText: subText,
        ),
      );
    }
  }

  Future<void> getData() async {
    store.dispatch(SetInfoMessageAction(infoMessage: 'Preparing browser...'));
    await launchBrowser();
    if (store.state.errorMessage == '') {
      String siteVersionMessage =
          'Scraping from https://www.google.co${site == SiteEnum.baseWebsite ? "m" : ".uk"}/';
      store.dispatch(SetInfoMessageAction(infoMessage: siteVersionMessage));
    }
    // click pop up
    var infoPopup = await _page.$$('.sy4vM');
    await infoPopup[0].click();
    // Check if there are 50 or more results on the page
    int totalResults = await checkResults();
    int loops = 0;
    while (totalResults < 50) {
      await _page.evaluate(
          '''() => { window.scrollTo(0, document.body.scrollHeight); }''');
      // If we're stuck in the loop for a while
      // look for the 'More results' button.
      if (loops > 500) {
        var btn = await _page.$OrNull('.ipz2Oe');
        if (btn != null) {
          await _page.evaluate(
              '''() => { window.scrollTo(0, document.body.scrollHeight); }''');
          await btn.click();
        }
      }
      totalResults = await checkResults();
      loops++;
    }
    var organicResults = await _page.$$(_organicSelector);
    var adResults = await _page.$$(_adSelector);
    await extractResultInfo(organicResults, adResults);
    //
    await closeBrowser();
    store.dispatch(SetInfoMessageAction(infoMessage: ''));
  }
}
