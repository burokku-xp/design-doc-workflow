# Design Doc Workflow — Cursor Plugin

人間が把握しやすい**詳細設計書**（表・図中心）を作成し、MCP 連携で設計 PR → 実装 Issue → きれいなコード実装 → レビュー → Playwright テストへつなぐ Cursor Plugin です。

**リポジトリ:** https://github.com/burokku-xp/design-doc-workflow

> **ステータス:** v0.2.3 — Cursor Marketplace 公開を想定

## インストール

### 重要: 別プロジェクトでも使うには

**Downloads から「Add from folder」だけだと、そのフォルダに紐づくだけで別プロジェクトでは Skills/Rules が出ません。**

全プロジェクトで使うには **User スコープ** で入れてください。

| 方法 | 全プロジェクト | 手順 |
|------|----------------|------|
| **A. ローカルインストール（推奨）** | ✅ | 下記 PowerShell 1 回 → Reload Window |
| **B. Customize から User インストール** | ✅ | Customize → User スコープ → プラグイン Install |
| **C. プロジェクトに bootstrap** | そのプロジェクトのみ | `bootstrap-project.ps1` |
| D. Add from folder（Downloads） | ❌ 別プロジェクトで未反映 | 非推奨 |

### A. 全プロジェクト向けインストール（Windows・推奨）

ZIP を展開したフォルダで PowerShell を開き:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install-to-cursor-local.ps1
```

→ `C:\Users\<you>\.cursor\plugins\local\design-doc-workflow\` にコピーされます。

その後:
1. Cursor → **Developer: Reload Window**
2. **Customize** → 左上スコープを **User（人型アイコン）** に切替
3. **Skills / Rules** に `design-doc` などが表示されるか確認
4. **Plugins → Configure** → `GITHUB_PAT` 設定

### B. Customize から User スコープでインストール

1. Customize を開く
2. 左上のスコープを **User** に変更（Workspace だとそのワークスペースだけ）
3. マーケットプレイス / インストール済みから `design-doc-workflow` を **Install → User**

### C. 特定プロジェクトだけに入れる（確実）

```powershell
powershell -ExecutionPolicy Bypass -File scripts/bootstrap-project.ps1 C:\path\to\your-project
```

→ プロジェクトの `.cursor/rules`, `.cursor/skills`, `.cursor/commands` にコピー。  
Customize → スコープを **そのプロジェクト名** に切替して確認。

### その他

1. **Git リポジトリから（推奨）** — https://github.com/burokku-xp/design-doc-workflow  
   Cursor → **Plugins → Add from Git** → 上記 URL → **Install 時に User を選択**
2. **ZIP 生成** — `bash scripts/package-plugin.sh` → `dist/design-doc-workflow-<version>.zip`

### パッケージ生成

```bash
bash scripts/validate-plugin.sh   # 構成チェック
bash scripts/package-plugin.sh    # dist/*.zip を生成
```

Marketplace 公開: [cursor.com/marketplace/publish](https://cursor.com/marketplace/publish) にリポジトリ URL を提出

### トラブルシューティング

| 症状 | 原因 | 対処 |
|------|------|------|
| 別プロジェクトで Skill が出ない | Workspace スコープ / Downloads フォルダ紐づけ | `install-to-cursor-local.ps1` または User スコープで再インストール |
| Customize に何もない | スコープが User 固定でプロジェクト側だけにある | スコープをプロジェクト名に切替 |
| `/design-doc` が無い | Commands 未ロード | Reload Window → Customize → Commands 確認 |
| MCP が動かない | GITHUB_PAT 未設定 | Plugins → Configure |

**Customize のスコープ切替が最重要です。** User = 全プロジェクト、プロジェクト名 = その repo の `.cursor/` のみ。

| コンポーネント | 内容 |
|----------------|------|
| **Skills** | design-doc, design-to-pr, design-to-issues, impl-from-design, impl-review, e2e-from-design, **workflow-router** |
| **Rules** | design-readonly, clean-code, **workflow-router** |
| **Commands** | 各 Skill に対応するスラッシュコマンド + **workflow-status** |
| **MCP** | GitHub（Issue/PR）+ Playwright（E2E デバッグ） |
| **Templates** | 設計書、GitHub、Playwright |

## クイックスタート

```
0. workflow-status → 今のフェーズ確認 & 次の Skill 提案（任意）
1. design-doc     → 設計書作成
2. 人間レビュー    → index.html
3. design-to-pr   → 設計PR（GitHub MCP）
4. design-to-issues → Epic + Sub-Issues
5. impl-from-design → 実装PR（clean-code）
6. impl-review    → コードレビュー
7. e2e-from-design → Playwright テスト
```

**workflow-router** Rule（`alwaysApply: true`）が会話中にフェーズを推定し、適切な Skill を短く提案します。明示的に確認する場合は `/workflow-status` または「今どのフェーズ？」。

## 思想

- **人間が仕様を握る** — 設計書は表・図。軽微な調整は同一 feat PR で可
- **きれいなコード** — 読みやすさ最優先（`clean-code` Rule）
- **Playwright 統一** — フロントテストはすべて Playwright
- **MCP 自動化** — GitHub Issue/PR、ブラウザデバッグ

## 連携 Skills

GitHub MCP / Playwright MCP / **subscribe** / **context7-mcp** との組み合わせ: [docs/workflow.md](docs/workflow.md#連携-skillscursor-既存環境)

## ディレクトリ構成

```
design-doc-workflow/
├── .cursor-plugin/plugin.json
├── mcp.json
├── skills/
├── rules/
├── commands/
├── templates/design|github|playwright/
├── examples/my-app/
└── docs/
```

## サンプル

`examples/my-app/features/user-auth/` — ユーザー認証（Playwright テスト設計含む）

## ライセンス

MIT — 詳細は [LICENSE](LICENSE)
