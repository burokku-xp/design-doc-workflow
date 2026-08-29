# フロー: ユーザー認証

## シーケンス: ログイン（正常系）

```mermaid
sequenceDiagram
  participant User
  participant LoginScreen
  participant LoginForm
  participant API
  participant AuthController
  participant AuthService
  participant UserRepository
  participant DB

  User->>LoginScreen: ログイン画面を開く
  User->>LoginForm: メール・パスワード入力
  User->>LoginForm: ログインボタン
  LoginForm->>API: POST /api/v1/auth/login
  API->>AuthController: login
  AuthController->>AuthService: login
  AuthService->>UserRepository: findByEmail
  UserRepository->>DB: SELECT
  DB-->>UserRepository: ユーザー
  UserRepository-->>AuthService: ユーザー
  AuthService-->>AuthController: トークン + ユーザー概要
  AuthController-->>API: 200
  API-->>LoginForm: 成功レスポンス
  LoginForm-->>LoginScreen: onSuccess
  LoginScreen-->>User: ダッシュボード表示
```

## シーケンス: ログイン（異常系）

```mermaid
sequenceDiagram
  participant User
  participant LoginForm
  participant API
  participant AuthService

  User->>LoginForm: 誤ったパスワードで送信
  LoginForm->>API: POST /api/v1/auth/login
  API->>AuthService: login
  AuthService-->>API: 認証失敗
  API-->>LoginForm: 401
  LoginForm-->>User: エラーメッセージ表示
```

## 状態遷移（ログインフォーム）

| 状態 | イベント | 次の状態 |
|------|----------|----------|
| idle | 送信 | submitting |
| submitting | 成功 | success（画面遷移） |
| submitting | 失敗 | error |
| error | 再入力 | idle |
