# Cloud Agent / モバイル / Web で使う

Cursor **Cloud Agent**（Web・iOS・Android PWA）は **あなたの PC の `~/.cursor/plugins/` を読みません**。

Skills / Rules を Cloud で使うには、**アプリの Git リポジトリに `.cursor/` をコミット**する必要があります。

公式: [Agent Skills — Cloud Agents](https://cursor.com/docs/skills)  
> use project skills from the repo or bake skills into the worker image

---

## クイックセットアップ（1 回）

アプリのリポジトリルートで:

```bash
curl -fsSL https://raw.githubusercontent.com/burokku-xp/design-doc-workflow/main/scripts/install-into-project.sh | bash
git add .cursor
git commit -m "chore: add design-doc-workflow skills for Cloud Agent"
git push
```

Windows:

```powershell
git clone https://github.com/burokku-xp/design-doc-workflow.git $env:TEMP\ddw
powershell -ExecutionPolicy Bypass -File $env:TEMP\ddw\scripts\bootstrap-project.ps1 (Get-Location).Path
git add .cursor
git commit -m "chore: add design-doc-workflow skills for Cloud Agent"
git push
```

---

## インストール後の `.cursor/` 構成

```
your-app/
└── .cursor/
    ├── skills/          # design-doc, impl-from-design, workflow-router など 7 件
    ├── rules/           # design-readonly, clean-code, workflow-router
    ├── commands/        # /design-doc など（レガシー互換）
    ├── design-doc-workflow.version
    └── README.md        # このワークフローの短い説明
```

Cloud Agent が repo を clone すると **自動で Skills / Rules を読み込み**ます。

---

## シークレット（GitHub MCP）

1. [cursor.com/dashboard](https://cursor.com/dashboard) → **Cloud Agents** → **Secrets**
2. `GITHUB_PAT` を追加（repo スコープ）
3. Cloud Agent 実行時に GitHub MCP を有効化

Playwright MCP は Cloud VM 上で動く場合がありますが、ローカル専用の操作は PC Agent 向けです。

---

## 使い方

Cloud / モバイル Agent でリポジトリを選び、例:

```
design-doc スキルで user-auth の設計書を作って
```

```
impl-from-design スキルで Issue #123 を実装して
```

```
今どのフェーズ？
```

---

## PC Plugin との違い

| 方式 | PC IDE | Cloud / Mobile |
|------|--------|----------------|
| Plugin Install（User） | ✅ | ❌ |
| `.cursor/` を repo にコミット | ✅ | ✅ **推奨** |
| `install-to-cursor-local.ps1` | ✅ | ❌ |

**両方やるのがベスト:** PC では Plugin、Cloud 用に `.cursor/` をコミット。

---

## 更新

Plugin を更新したら、プロジェクトで再実行:

```bash
curl -fsSL https://raw.githubusercontent.com/burokku-xp/design-doc-workflow/main/scripts/install-into-project.sh | bash
git add .cursor && git commit -m "chore: update design-doc-workflow skills"
```

---

## 関連

- [docs/workflow.md](workflow.md) — 5 Phase ワークフロー
- [README](../README.md) — Plugin 概要
