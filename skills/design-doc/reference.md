# Design Doc Reference

## manifest-schema

```yaml
project: my-app
title: My Application
status: draft  # draft | review | approved

features:
  - id: user-auth
    title: ユーザー認証
    status: draft
    depends_on: []
    docs:
      readme: features/user-auth/README.md
      functional: features/user-auth/functional.md
      api: features/user-auth/api.md
      layers: features/user-auth/layers.md
      db: features/user-auth/db.md
      screens: features/user-auth/screens.md
      components: features/user-auth/components.md
      flows: features/user-auth/flows.md
      tests: features/user-auth/tests.md
    requirements:
      - id: REQ-AUTH-001
        title: メールアドレスでログインできる
        acceptance: features/user-auth/functional.md#req-auth-001
        apis: [API-AUTH-001]
        screens: [SCR-AUTH-001]
        components: [CMP-AUTH-001]
        tests: [TST-AUTH-001]
```

## README template

```markdown
# [機能名]

## 概要
[2〜3文で目的]

## スコープ
| 含む | 含まない |
|------|----------|
| ... | ... |

## 関連一覧
| 種別 | ID | 名前 |
|------|-----|------|
| 画面 | SCR-xxx | ... |
| API | API-xxx | ... |
| DB | TBL-xxx | ... |

## 依存機能
- なし / [feature-id]

## 受け入れ条件
- [ ] REQ-xxx: ...
```

## functional.md template

```markdown
# 機能設計: [機能名]

## ユースケース
| UC-ID | 操作者 | やりたいこと | 結果 |
|-------|--------|--------------|------|

## ビジネスルール
| BR-ID | ルール | 例外時の振る舞い |
|-------|--------|------------------|

## 要件
### REQ-xxx: [タイトル]
[1〜2文の説明]
```

## api.md template

```markdown
# API設計: [機能名]

## API一覧
| API-ID | メソッド | パス | 概要 | 主な入力 | 主な出力 | 認証 |
|--------|----------|------|------|----------|----------|------|

## エラー
| 条件 | HTTP | ユーザーへの表示 |
|------|------|------------------|
```

## layers.md template

```markdown
# 層設計: [機能名]

## 責務マトリクス
| 層 | クラス | 責務 | 関連API |
|----|--------|------|---------|
| Controller | XxxController | HTTP受付 | API-xxx |
| Service | XxxService | ビジネスロジック | — |
| Repository | XxxRepository | データアクセス | — |

## 主要メソッド
| 層 | メソッド | やること |
|----|----------|----------|
```

## db.md template

```markdown
# データ設計: [機能名]

## ER図
\`\`\`mermaid
erDiagram
  USERS ||--o{ SESSIONS : has
\`\`\`

## テーブル: TBL-xxx [テーブル名]
| カラム | 型 | 必須 | 説明 |
|--------|-----|------|------|
```

## screen-design

Screen design order: **use cases → screen cards → transition diagram → traceability matrix → components.md**

For complex flows (wizard, approval chain), write user-perspective sequence in `flows.md` first, then derive screens.

## screens.md template

```markdown
# 画面設計: [機能名]

## ユースケースと画面の対応
| UC-ID | 必要な画面 |
|-------|------------|
| UC-xxx | SCR-xxx |

## 画面一覧
| SCR-ID | 名前 | ルート | 主な操作 | 呼ぶAPI |
|--------|------|--------|----------|---------|

## 画面遷移
\`\`\`mermaid
flowchart LR
  A[SCR-xxx 画面A] -->|操作| B[SCR-yyy 画面B]
\`\`\`

## 対応マトリクス
| SCR-ID | 画面 | 関連REQ | 呼ぶAPI | 主コンポーネント | 遷移先 |
|--------|------|---------|---------|------------------|--------|

---

## SCR-xxx: [画面名]

### 目的
[この画面が存在する理由を1〜2文で]

### レイアウト
| エリア | 要素 | 動作 |
|--------|------|------|
| 上部 | ... | ... |
| 中央 | ... | ... |
| 下部 | ... | ... |

### ワイヤー（ASCII）
\`\`\`
┌─────────────────┐
│     [要素]      │
├─────────────────┤
│ [ 入力欄      ] │
│  [ ボタン ]     │
└─────────────────┘
\`\`\`

### 状態
| 状態 | 見た目・振る舞い |
|------|------------------|
| 初期 | ... |
| 送信中 | ボタン無効・スピナー |
| エラー | エラーメッセージ表示 |
| 成功 | 次画面へ遷移 |

### 操作と結果
| 操作 | 条件 | 結果 |
|------|------|------|
| [ボタン名] | ... | ... |
```

## components.md note

Write **after** `screens.md` is stable. Each CMP-ID must map to a parent screen in the traceability matrix.

## components.md template

```markdown
# UIコンポーネント: [機能名]

## コンポーネントツリー
\`\`\`mermaid
flowchart TD
  Page --> Form
  Form --> FieldA
\`\`\`

## コンポーネント一覧
| CMP-ID | 名前 | 役割 | 親 | 主な入出力 |
|--------|------|------|-----|------------|
```

## flows.md template

```markdown
# フロー: [機能名]

## シーケンス: [フロー名]
\`\`\`mermaid
sequenceDiagram
  participant User
  participant Screen
  participant API
  participant Service
  participant DB
\`\`\`

## 状態遷移
| 状態 | イベント | 次の状態 |
|------|----------|----------|
```

## tests.md template

Playwright for all frontend tests. See `templates/design/features/_template/tests.md`.

```markdown
# テスト設計: [機能名]

## トレーサビリティ
| TST-ID | 種別 | 対象 | 観点 | 関連REQ | 関連SCR/CMP | Playwright spec |
|--------|------|------|------|---------|-------------|-----------------|

種別: E2E = Playwright E2E, CT = Playwright Component Test

## E2E シナリオ
| TST-ID | 画面 | 操作 | 期待結果 |

## コンポーネントシナリオ
| CMP-ID | TST-ID | 観点 | 期待結果 |

## バックエンド（JUnit）
| TST-ID | 層 | 観点 | 関連REQ |
```

## html-index

Minimal dashboard structure:

```html
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>[project] 設計書</title>
  <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
  <style>
    body { font-family: sans-serif; max-width: 960px; margin: 2rem auto; padding: 0 1rem; }
    table { border-collapse: collapse; width: 100%; margin: 1rem 0; }
    th, td { border: 1px solid #ccc; padding: 0.5rem; text-align: left; }
    th { background: #f5f5f5; }
    .feature-card { border: 1px solid #ddd; padding: 1rem; margin: 1rem 0; border-radius: 4px; }
    .status-draft { color: #888; }
    .status-approved { color: #080; }
  </style>
</head>
<body>
  <h1>[project] 詳細設計書</h1>
  <p>ステータス: <span class="status-draft">draft</span></p>
  <!-- Feature cards, traceability table, links to 00-project/ -->
  <script>mermaid.initialize({ startOnLoad: true });</script>
</body>
</html>
```

Regenerate from `manifest.yaml` content whenever features change.
