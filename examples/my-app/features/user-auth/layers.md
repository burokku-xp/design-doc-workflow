# 層設計: ユーザー認証

## 責務マトリクス

| 層 | クラス | 責務 | 関連API |
|----|--------|------|---------|
| Controller | AuthController | リクエスト受付・バリデーション・レスポンス返却 | API-AUTH-001 |
| Service | AuthService | 認証ロジック・トークン発行 | — |
| Repository | UserRepository | メールアドレスでユーザー検索 | — |

## 主要メソッド

| 層 | メソッド | やること |
|----|----------|----------|
| Controller | login | ログインリクエストを受け取り結果を返す |
| Service | login | パスワード検証しトークンを生成する |
| Service | validateCredentials | メール・パスワードの整合性を確認する |
| Repository | findByEmail | メールアドレスでユーザーを検索する |

## 例外（ドメイン）

| 例外 | 意味 | HTTP |
|------|------|------|
| InvalidCredentialsException | 認証失敗 | 401 |
