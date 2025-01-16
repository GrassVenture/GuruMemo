## 環境構築

### 1. 本リポジトリをクローン後、プロジェクトのルートディレクトリにて以下のコマンドを実行する。

```bash
make setup
```

本プロジェクトではFlutterバージョンの管理にfvmを使っている。  
詳細は[こちらの記事](https://zenn.dev/altiveinc/articles/flutter-version-management)を参照。

### 2. `.env.example`をコピーして`.env`を作成する。
PROD_API_URLとDEV_API_URLをNotionを参照して変更する。

```.dotenv
PROD_API_URL=https://dummy-prod-url
DEV_API_URL=https://dummy-dev-url
```

実際のURLは以下を参照：  
https://www.notion.so/masakisato/11a5050794ac414f8f0ef9525ae13809?pvs=4

### 3. Firebaseにsha1証明書を登録する。
   my-gourmetとmy-gourmet-devに下記で出力されたsha1証明書を登録する。
```
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

詳細は、以下のURLを参照：  
https://zenn.dev/flutteruniv/books/flutter-textbook/viewer/make-chat

## 開発手法
### Issue管理
全てNotion上で行う。
以下スペース(アクセス権限必要)：  
https://www.notion.so/masakisato/MyGourmet-4932e4554a4246849be5f53fdfa4c0c8

### PR作成方法
GitHubとNotionの相互紐付けを行う。  
1. NotionのドキュメントIDを確認  
![CleanShot 2024-09-02 at 07 48 44](https://github.com/user-attachments/assets/a4ba90b2-5304-4794-bf15-eabd8fb47567)
2. PRのタイトルに記載  
![CleanShot 2024-09-02 at 07 51 02@2x](https://github.com/user-attachments/assets/fb118922-72e6-4745-b18f-eced891762a5)

## ディレクトリ構成
### features ディレクトリ
各機能ごとに`features`ディレクトリに格納する、`feature-first`という方式を取っている

- `xxx_page.dart` :  画面描画やlocal stateの管理を担当
    - 例: [sign_in_page.dart](https://github.com/MyGourmet/My_Gourmet/blob/dev/lib/features/auth/sign_in_page.dart)
    - 画面の描画を行う
        - 共通化が可能なウィジェットは自身のfeature内 or `core` ディレクトリ側でコンポーネント化する
    - クラス内で完結するローカルな状態管理は`flutter_hooks`を用いて行う
        - ボタンのonPressedを丸ごとcontroller側で行うような運用にすると返って複雑な状態管理となってしまうので行わない
        - 参考: https://riverpod.dev/docs/essentials/do_dont#avoid-using-providers-for-ephemeral-state
    - スナックバー表示などのエラーハンドリングもここで行う
- `xxx_controller.dart`: 外部サービス接続の橋渡し及びグローバルな状態管理を担当
    - 例: [auth_controller.dart](https://github.com/MyGourmet/My_Gourmet/blob/dev/lib/features/auth/auth_controller.dart)
    - 外部サービスの利用時、画面側との橋渡し役としてリポジトリへ接続する
    - グローバルに扱いたい状態管理もここで行う
- `xxx_repository.dart` : 外部サービスへの接続を担当
    - 例: [auth_repository.dart](https://github.com/MyGourmet/My_Gourmet/blob/dev/lib/features/auth/auth_repository.dart)
    - FirestoreやStorageといったデータソースへの接続はこのレイヤーのクラスから行う
    - アプリ上で必要なモデルクラスへの関連したロジックもここに記載する

### core ディレクトリ
- featureを横断して利用するものはこの`core`ディレクトリへ格納する
- UIコンポーネントについては、featureを超えて共通化する場合は、`core` ディレクトリ内の `widgets` ディレクトリへ 格納する
- UIが存在せずに外部サービスと接続するようなファイル(ie. `analytics_repository.dart`)は、`feature`ディレクトリではなく`core`ディレクトリへ入れることを検討

```text
.
├── core
│   ├── analytics_repository.dart
│   ├── constants.dart
│   ├── themes.dart
│   └── widgets
│       ├── confirm_dialog.dart
│       └── success_snack_bar.dart
├── features
│   ├── auth
│   │   ├── auth_controller.dart
│   │   ├── auth_repository.dart
│   │   ├── authed_user.dart
│   │   ├── authed_user.freezed.dart
│   │   ├── authed_user.g.dart
│   │   └── my_page.dart
│   └── root_page.dart
└── main.dart


```
