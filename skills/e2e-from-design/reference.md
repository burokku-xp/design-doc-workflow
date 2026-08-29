# Playwright Templates Reference

## Directory layout (user project)

```
tests/
├── e2e/
│   └── TST-<FEATURE>-<NNN>.spec.ts
└── components/
    └── CMP-<FEATURE>-<NNN>.spec.ts
playwright.config.ts
```

## E2E spec pattern

```typescript
import { test, expect } from '@playwright/test';

// TST-AUTH-001: メールでログインできる
test('TST-AUTH-001: login with valid credentials', async ({ page }) => {
  await page.goto('/login');
  await page.getByLabel('メールアドレス').fill('user@example.com');
  await page.getByLabel('パスワード').fill('password123');
  await page.getByRole('button', { name: 'ログイン' }).click();
  await expect(page).toHaveURL('/dashboard');
});
```

## Component spec pattern

```typescript
import { test, expect } from '@playwright/experimental-ct-react';
import { LoginForm } from '../../src/features/auth/LoginForm';

// CMP-AUTH-001
test('CMP-AUTH-001: shows validation error for invalid email', async ({ mount }) => {
  const component = await mount(<LoginForm onSuccess={() => {}} />);
  await component.getByLabel('メールアドレス').fill('invalid');
  await component.getByRole('button', { name: 'ログイン' }).click();
  await expect(component.getByText(/メール/)).toBeVisible();
});
```

## CI (GitHub Actions snippet)

```yaml
- name: Install Playwright
  run: npx playwright install --with-deps
- name: Run Playwright tests
  run: npx playwright test
```

## Playwright MCP debug flow

1. Navigate to local dev URL
2. `browser_snapshot` to get element refs
3. Interact with `browser_click`, `browser_type`
4. Translate working flow into spec file
