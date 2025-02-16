String formatAddress(String fullAddress) {
  // 変更なし
  final postalCodeIndex = fullAddress.indexOf('〒');

  // もし '〒' が見つからない場合、そのまま fullAddress を返す
  if (postalCodeIndex == -1) {
    return fullAddress;
  }

  // '〒' の次のスペースが見つからない場合、そのまま fullAddress を返す
  final spaceIndex = fullAddress.indexOf(' ', postalCodeIndex);
  if (spaceIndex == -1) {
    return fullAddress;
  }

  final postalCode = fullAddress.substring(postalCodeIndex, spaceIndex);
  final address = fullAddress.substring(spaceIndex + 1);

  return '$postalCode\n$address';
}
