class Scraper {
  final String defaultUrl = 'https://www.google.com/';
  final String ukUrl = 'https://www.google.co.uk/';
  final String searchTerm;
  final dynamic store;

  Scraper({
    required this.searchTerm,
    required this.store,
  });
}
