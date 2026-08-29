# テスト設計: ユーザー認証

## トレーサビリティ

| TST-ID | 種別 | 対象 | 観点 | 関連REQ | 関連SCR/CMP | Playwright spec |
|--------|------|------|------|---------|-------------|-----------------|
| TST-AUTH-001 | E2E | ログイン全体 | 正常系：正しい認証情報 | REQ-AUTH-001 | SCR-AUTH-001 | tests/e2e/TST-AUTH-001.spec.ts |
| TST-AUTH-002 | E2E | ログイン全体 | 異常系：誤ったパスワード | REQ-AUTH-002 | SCR-AUTH-001 | tests/e2e/TST-AUTH-002.spec.ts |
| TST-AUTH-003 | CT | LoginForm | バリデーション：メール形式 | BR-AUTH-001 | CMP-AUTH-001 | tests/components/CMP-AUTH-001.spec.ts |
| TST-AUTH-004 | CT | LoginForm | バリデーション：パスワード長 | BR-AUTH-002 | CMP-AUTH-001 | tests/components/CMP-AUTH-001.spec.ts |
| TST-AUTH-005 | — | AuthService | 単体：認証成功 | REQ-AUTH-001 | — | JUnit |
| TST-AUTH-006 | — | AuthService | 単体：認証失敗 | REQ-AUTH-002 | — | JUnit |
| TST-AUTH-007 | — | AuthController | 結合：401 返却 | REQ-AUTH-002 | API-AUTH-001 | MockMvc |

## E2E シナリオ

| TST-ID | 画面 | 操作 | 期待結果 |
|--------|------|------|----------|
| TST-AUTH-001 | SCR-AUTH-001 | 正しいメール・パスワードでログイン | ダッシュボード（/dashboard）が表示される |
| TST-AUTH-002 | SCR-AUTH-001 | 誤ったパスワードでログイン | 「メールまたはパスワードが違います」が表示され /login に留まる |

### TST-AUTH-001 Playwright 概要

```typescript
// tests/e2e/TST-AUTH-001.spec.ts
test('TST-AUTH-001: login with valid credentials', async ({ page }) => {
  await page.goto('/login');
  await page.getByLabel('メールアドレス').fill('user@example.com');
  await page.getByLabel('パスワード').fill('validpassword');
  await page.getByRole('button', { name: 'ログイン' }).click();
  await expect(page).toHaveURL('/dashboard');
});
```

### TST-AUTH-002 Playwright 概要

```typescript
// tests/e2e/TST-AUTH-002.spec.ts
test('TST-AUTH-002: shows error on invalid password', async ({ page }) => {
  await page.goto('/login');
  await page.getByLabel('メールアドレス').fill('user@example.com');
  await page.getByLabel('パスワード').fill('wrongpassword');
  await page.getByRole('button', { name: 'ログイン' }).click();
  await expect(page.getByText('メールまたはパスワードが違います')).toBeVisible();
  await expect(page).toHaveURL('/login');
});
```

## コンポーネントシナリオ

| CMP-ID | TST-ID | 観点 | 期待結果 |
|--------|--------|------|----------|
| CMP-AUTH-001 | TST-AUTH-003 | 無効なメール形式 | メール欄下にバリデーションエラー |
| CMP-AUTH-001 | TST-AUTH-004 | パスワード8文字未満 | パスワード欄下にバリデーションエラー |

### CMP-AUTH-001 Playwright CT 概要

```typescript
// tests/components/CMP-AUTH-001.spec.ts
test('TST-AUTH-003: invalid email shows validation error', async ({ mount }) => {
  const component = await mount(<LoginForm onSuccess={() => {}} />);
  await component.getByLabel('メールアドレス').fill('not-an-email');
  await component.getByRole('button', { name: 'ログイン' }).click();
  await expect(component.getByText(/メール/)).toBeVisible();
});
```

## バックエンド（JUnit）

| TST-ID | 層 | 観点 |
|--------|-----|------|
| TST-AUTH-005 | AuthService | 正しい認証情報でトークン返却 |
| TST-AUTH-006 | AuthService | 誤ったパスワードで InvalidCredentialsException |
| TST-AUTH-007 | AuthController | 認証失敗時 HTTP 401 |

## 受け入れ条件マッピング

| REQ-ID | カバーする TST-ID |
|--------|-------------------|
| REQ-AUTH-001 | TST-AUTH-001, TST-AUTH-005 |
| REQ-AUTH-002 | TST-AUTH-002, TST-AUTH-003, TST-AUTH-004, TST-AUTH-006, TST-AUTH-007 |

## テスト実行

```bash
# E2E
npx playwright test tests/e2e

# コンポーネント
npx playwright test tests/components

# バックエンド
./mvnw test
```

Playwright MCP でローカルデバッグ → `e2e-from-design` Skill 参照。
