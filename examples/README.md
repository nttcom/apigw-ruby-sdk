サンプルスクリプト実行方法
===

前準備
---

```
$ cd /path/to/apigw-lib-ruby
$ bundle install --path vendor/bundle

$ cd examples
```

request_access_token.rb
---

アクセストークン取得サンプルスクリプト

```
$ export CONSUMER_KEY=<コンシューマーキー> export SECRET_KEY=<シークレットキー> bundle exec ./request_access_token.rb
```

get_contracts.rb
---

契約一覧を取得するサンプルスクリプト

```
$ export ACCESS_TOKEN=<アクセストークン> export SERVICE_NAME=<サービス名> bundle exec ./get_contracts.rb
```

get_api_log.rb
---

本日分のAPI Logを取得するサンプルスクリプト

```
$ export ACCESS_TOKEN=<アクセストークン> bundle exec ./get_api_log.rb
```
