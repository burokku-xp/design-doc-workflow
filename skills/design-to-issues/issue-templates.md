# Issue Templates Reference

## Sub-issue optional sections

### Backend scope hint

```markdown
## Backend（Java Spring Boot）
| 層 | 対象 | 設計参照 |
|----|------|----------|
| Controller | AuthController | layers.md |
| Service | AuthService | layers.md |
| Repository | UserRepository | layers.md + db.md |
```

### Frontend scope hint

```markdown
## Frontend（React）
| CMP-ID | 名前 | 設計参照 |
|--------|------|----------|
| CMP-AUTH-001 | LoginForm | components.md |
```

### Test checklist

```markdown
## テスト
| TST-ID | 観点 | 種別 |
|--------|------|------|
| TST-AUTH-001 | 正常ログイン | 結合 |
| TST-AUTH-002 | 認証失敗 | 単体 + UI |
```

## GitHub CLI example

If `gh` is available:

```bash
gh issue create \
  --title "[user-auth] REQ-AUTH-001: メールでログインできる" \
  --label "implementation,user-auth" \
  --body-file /tmp/issue-body.md
```

## gh unavailable

Provide issue title and body in chat for user to paste, or use GitHub web UI.
