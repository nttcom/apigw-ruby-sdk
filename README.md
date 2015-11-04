NTT Communications API SDK(ruby)
===

このライブラリは、NTT Communications APIsと対話的にアクセスするための簡易的なラッパーを提供します。
各APIの仕様については、[デベロッパーポータル](https://developer.ntt.com/ja)のドキュメントを参照ください。

セットアップ
---

### Bundler での使用

Gemfile に下記を追記し、`bundle install`

```ruby
gem 'apigw'
```

システム要件
---

Ruby 2.0.0 以上

使い方
---

2015/10現在、クライアントは

* OAuth API
* Business Process API
* APILog API
* IAM API

の4つのAPIへのアクセスを提供します。

### クライアントの生成

クライアントの生成時には、エンドポイントの情報を記載したYAML形式の設定ファイルへのパスを指定します。

```ruby
client = ApiGW::Client.new(config_path: 'path/to/config.yml', environment: 'development')
```

設定ファイル例:

```yaml
development:
  host: "ホスト名"(e.g. 'https://api.ntt.com/')
  api_version: "APIバージョン"(e.g. 'v1')
  timeout: タイムアウト(ms)
  verify_ssl: SSL証明書の検証を行うか(true / false)
  debuggable: デバッグ情報を表示するか(true / false)
```

※ host と api_version は必須となります。

### アクセストークンの取得

[デベロッパーポータル](https://developer.ntt.com/ja) にて払い出されたコンシューマーキーとシークレットキーを指定します。

```ruby
response = client.oauth('コンシューマーキー', 'シークレットキー').access_token
access_token = response.body['accessToken']
```

全てのAPIのレスポンスは [Faraday::Response](https://github.com/lostisland/faraday/blob/master/lib/faraday/response.rb) オブジェクトで返却されます。
レスポンスのJSONは `Faraday::Response#body` からHash形式にパースされた状態で取得できます。
各APIのレスポンス仕様については、[デベロッパーポータル](https://developer.ntt.com/ja)のドキュメントを参照ください。

### Business Process API

OAuth API にて取得したアクセストークンとAPIパス、サービス名称を指定します。

```ruby
response = client.business_process('アクセストークン').get('contracts', 'サービス名称')
items = response.body['items']
```

情報の参照には `ApiGW::BusinessProcess#get(...)` を、各種オーダには `ApiGW::BusinessProcess#post(...)` を利用します。

### APILog API

OAuth API にて取得したアクセストークンと利用履歴の対象日を指定します。

```ruby
response = client.api_log('アクセストークン').get('日付(YYYYMMDD)')
records = response.body['Records']
```

### その他API

examples/を参考にしてください。

ApiGW::ApiBase の継承について
---

新しいAPIに対応したクラスを作成する場合は、`ApiGW::ApiBase`のサブクラスを実装します。
以下のドキュメント及び `ApiGW::BusinessProcess` や `ApiGW::ApiLog` を参考に実装してください。

### 実装が必要なクラスメソッド

#### `api_name()`

APIの名称を返すメソッドです。

`https://api.ntt.com/v1/xxxxxx/yyyyyy` の `xxxxxx` の部分を返します。
例えば `ApiGW::BusinessProcess` では `business-process` 、 `ApiGW:ApiLog` では `apilog` を返すよう実装されています。

api_name をオーバーライドしないと NotImplementedError が発生します。

#### `require_authorization?()`

このAPIに認証(アクセストークン)が必要かを返します。デフォルトでは false です。

trueを返すようにすると、リクエストヘッダーに `Authorization` を自動で付加するようになります。

### リクエスト時に使用するインスタンスメソッド

#### `XXX_request(path, opts = {})`

`get_request`, `post_request`, `put_request`, `delete_request`, `options_request` の5つが定義されています。
それぞれ GET, POST, PUT, DELETE, OPTIONS のリクエストを実行し、結果を返します。

`path` は `https://api.ntt.com/v1/xxxxxx/yyyyyy` の `yyyyyy` の部分を渡します。
`yyyyyy` に相当するパスがないAPIの場合、 `nil` を指定します。


ライセンス
---
Copyright © 2015 NTT Communications  
[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
