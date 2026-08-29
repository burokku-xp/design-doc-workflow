# Design Doc Example: user-auth

Minimal example for `docs/design/my-app/features/user-auth/`.

## README.md (excerpt)

```markdown
# ユーザー認証

## 概要
メールアドレスとパスワードでログインし、ダッシュボードへ遷移する。

## 関連一覧
| 種別 | ID | 名前 |
|------|-----|------|
| 画面 | SCR-AUTH-001 | ログイン画面 |
| API | API-AUTH-001 | ログイン |
| DB | TBL-USERS | users |

## 受け入れ条件
- [ ] REQ-AUTH-001: 正しい認証情報でログインできる
- [ ] REQ-AUTH-002: 誤った認証情報でエラーが表示される
```

## api.md (excerpt)

```markdown
| API-ID | メソッド | パス | 概要 | 主な入力 | 主な出力 | 認証 |
|--------|----------|------|------|----------|----------|------|
| API-AUTH-001 | POST | /api/v1/auth/login | ログイン | メール・パスワード | トークン・ユーザー概要 | 不要 |
```

## layers.md (excerpt)

```markdown
| 層 | クラス | 責務 | 関連API |
|----|--------|------|---------|
| Controller | AuthController | リクエスト受付・レスポンス返却 | API-AUTH-001 |
| Service | AuthService | 認証・トークン発行 | — |
| Repository | UserRepository | メールでユーザー検索 | — |
```

## screens.md (excerpt)

```markdown
## SCR-AUTH-001: ログイン画面

### 目的
未認証ユーザーを認証し、ダッシュボードへ遷移させる。

### レイアウト
| エリア | 要素 | 動作 |
|--------|------|------|
| 中央 | メール入力 | テキスト入力 |
| 下部 | ログインボタン | フォーム送信 |

### 状態
| 状態 | 見た目・振る舞い |
|------|------------------|
| 送信中 | ボタン無効・スピナー |
| 認証エラー | フォーム上部にエラーメッセージ |

## 対応マトリクス
| SCR-ID | 画面 | 関連REQ | 呼ぶAPI | 主コンポーネント | 遷移先 |
| SCR-AUTH-001 | ログイン | REQ-AUTH-001 | API-AUTH-001 | CMP-AUTH-001 | ダッシュボード |
```

## components.md (excerpt)

```markdown
\`\`\`mermaid
flowchart TD
  LoginPage --> LoginForm
  LoginForm --> EmailField
  LoginForm --> PasswordField
  LoginForm --> SubmitButton
\`\`\`

| CMP-ID | 名前 | 役割 | 親 | 主な入出力 |
|--------|------|------|-----|------------|
| CMP-AUTH-001 | LoginForm | ログイン入力全体 | LoginPage | 入力値を送信イベントで親に渡す |
```

## flows.md (excerpt)

```markdown
\`\`\`mermaid
sequenceDiagram
  participant User
  participant LoginScreen
  participant API
  participant AuthService
  participant DB
  User->>LoginScreen: ログイン操作
  LoginScreen->>API: 認証リクエスト
  API->>AuthService: login
  AuthService->>DB: ユーザー検索
  DB-->>AuthService: ユーザー情報
  AuthService-->>API: トークン
  API-->>LoginScreen: 成功
  LoginScreen-->>User: ダッシュボードへ
\`\`\`
```
