class Country {
  String countryName;
  String countryFlag;
  Country({required this.countryName, required this.countryFlag});
}

List<Country> countries = [
  Country(countryName: 'مصر', countryFlag: getCountryCode('eg')),
  Country(countryName: 'امريكا', countryFlag: getCountryCode('us')),
  Country(countryName: 'امريكا', countryFlag: getCountryCode('us')),
  Country(countryName: 'امريكا', countryFlag: getCountryCode('us')),
  Country(countryName: 'امريكا', countryFlag: getCountryCode('us')),
  Country(countryName: 'امريكا', countryFlag: getCountryCode('us')),
  Country(countryName: 'امريكا', countryFlag: getCountryCode('us')),
  Country(countryName: 'امريكا', countryFlag: getCountryCode('us')),

];
//String countryCode = 'us';
String getCountryCode(String countryCode)
{

  return countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
          (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
}