/// アプリの実行環境を表すenum
enum Flavor {
  dev,
  prod;

  static Flavor get fromEnvironment {
    const value = String.fromEnvironment('FLAVOR');
    return Flavor.values.byName(value);
  }

  /// 本番環境かどうか
  bool get isProd => name == 'prod';
}

/// 別ファイルから用いるグローバル変数
final Flavor flavor = Flavor.fromEnvironment;
