# Plugin 開発ガイド

このリポジトリは **Cursor Plugin**（`design-doc-workflow`）として公開することを想定して構成されています。

## フォーマット

[Cursor Plugins リファレンス](https://cursor.com/docs/reference/plugins) に準拠。

| 項目 | パス |
|------|------|
| マニフェスト | `.cursor-plugin/plugin.json` |
| MCP | `mcp.json` |
| Skills | `skills/*/SKILL.md` |
| Rules | `rules/*.mdc` |
| Commands | `commands/*.md` |
| テンプレート | `templates/` |
| サンプル | `examples/` |

## コンポーネント一覧

### Skills

| Skill | Phase | 役割 |
|-------|-------|------|
| `workflow-router` | 横断 | 作業状態の検出と次 Skill の提案 |
| `design-doc` | 1 | 設計書作成 |
| `design-to-pr` | 1 | 設計 PR（GitHub MCP / gh） |
| `design-to-issues` | 2 | Epic + Sub-Issue 作成 |
| `impl-from-design` | 3 | 設計書参照して実装 |
| `impl-review` | 4 | コードレビュー |
| `e2e-from-design` | 5 | Playwright テスト生成・実行 |

### Rules

| Rule | 用途 |
|------|------|
| `workflow-router.mdc` | フェーズ推定と Skill 提案（`alwaysApply: true`） |
| `design-readonly.mdc` | 通常は読み取り専用。軽微な調整は同一 feat PR 内で可 |
| `clean-code.mdc` | 読みやすいコード（Java + React） |

### Commands

| Command | Skill |
|---------|-------|
| `/design-doc` | design-doc |
| `/design-to-pr` | design-to-pr |
| `/design-to-issues` | design-to-issues |
| `/impl-from-design` | impl-from-design |
| `/impl-review` | impl-review |
| `/e2e-from-design` | e2e-from-design |
| `/workflow-status` | workflow-router |

### MCP（実装済み）

| Server | Skills |
|--------|--------|
| GitHub MCP | design-to-pr, design-to-issues, impl-from-design |
| Playwright MCP | e2e-from-design |
| cursor-subscriptions | impl-from-design, impl-review, e2e-from-design（via subscribe skill） |

Integration guide: [`skills/_shared/workflow-integrations.md`](../skills/_shared/workflow-integrations.md)

User installs GitHub + Playwright MCP in Cursor Settings, or copies plugin `mcp.json`.

### 連携 Skills（Cursor 既存）

| Skill | 組み合わせ |
|-------|------------|
| **subscribe** | PR push 後に CI/レビュー待ち |
| **context7-mcp** | impl-from-design 中のライブラリ参照 |
| spec-to-implementation / tasks-build | Notion トラック（GitHub の代替） |

### Templates

| パス | コピー先 |
|------|----------|
| `templates/design/` | `docs/design/<project>/` |
| `templates/github/` | `.github/` |
| `templates/playwright/` | プロジェクトルート（Playwright 初回セットアップ） |

## ローカル開発・テスト

### 全プロジェクトで使う（推奨）

```powershell
# Windows（ZIP 展開フォルダで）
powershell -ExecutionPolicy Bypass -File scripts/install-to-cursor-local.ps1
```

```bash
# macOS / Linux
bash scripts/install-to-cursor-local.sh
```

→ `%USERPROFILE%\.cursor\plugins\local\design-doc-workflow\` に配置。  
**Developer: Reload Window** 後、Customize → **User** スコープで Skills/Rules を確認。

### 1 プロジェクトだけに入れる

```powershell
powershell -ExecutionPolicy Bypass -File scripts/bootstrap-project.ps1 C:\path\to\project
```

### 注意: Add from folder だけでは不十分

Downloads からフォルダ追加すると「Added 1 plugin」と出ても、**別プロジェクトでは Skills/Rules が読まれない**ことがあります。上記 `install-to-cursor-local` か Customize の **User スコープ Install** を使ってください。

### Cloud Agent / モバイル / Web

Plugin は Cloud VM にコピーされません。**アプリ repo の `.cursor/` に Skills をコミット**してください。

```bash
curl -fsSL https://raw.githubusercontent.com/burokku-xp/design-doc-workflow/main/scripts/install-into-project.sh | bash
```

詳細: [docs/cloud-agent.md](../docs/cloud-agent.md)

### 確認手順

1. `bash scripts/validate-plugin.sh`
2. Cursor → Developer: Reload Window
3. Customize → スコープ **User** → Skills 7 件 / Rules 3 件
4. Plugins → Configure → `GITHUB_PAT`
5. 別プロジェクトを開いて `/design-doc` または `design-doc スキルで...` を試す

### 配布物の生成

```bash
bash scripts/package-plugin.sh
# → dist/design-doc-workflow-<version>.zip
```

確認項目:
- [ ] 設計書スキャフォールド
- [ ] GitHub MCP または gh で Issue/PR 作成
- [ ] clean-code / design-readonly ルール適用
- [ ] Playwright テンプレ生成

## Marketplace 公開

1. `plugin.json` version / description 確定
2. `docs/workflow.md` 整備
3. [cursor.com/marketplace/publish](https://cursor.com/marketplace/publish) から提出

### 公開前チェックリスト

- [ ] `plugin.json` name ユニーク（kebab-case）
- [ ] `.cursor-plugin/marketplace.json` あり（ローカルフォルダ追加に必須）
- [ ] 全 Skill / Rule に frontmatter
- [ ] `variables.GITHUB_PAT` 宣言、mcp.json は `${GITHUB_PAT}` のみ（秘密値なし）
- [ ] `logo.svg` コミット済み
- [ ] README + workflow.md 完備

## 将来の拡張

| 機能 | 状態 |
|------|------|
| GitHub MCP | 実装済み |
| Playwright MCP | 実装済み |
| subscribe / context7-mcp 連携 | 実装済み |
| workflow-router（状態検出・Skill 提案） | 実装済み |
| Figma MCP | 未実装（オプション） |
| `hooks/` 設計書ガード | 未実装 |
| Agent Plugins 互換 | 未実装 |

## バージョニング

- **patch** — テンプレ修正
- **minor** — Skill 追加
- **major** — 破壊的変更（ID 体系など）
