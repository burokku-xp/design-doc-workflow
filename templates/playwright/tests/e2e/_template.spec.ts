import { test, expect } from '@playwright/test';

/**
 * TST-XXX-NNN: <scenario title from tests.md>
 * REQ: REQ-XXX-NNN
 * SCR: SCR-XXX-NNN
 */
test('TST-XXX-NNN: <scenario description>', async ({ page }) => {
  // Given: <from tests.md scenario>
  await page.goto('/<route>');

  // When: <user action from screens.md>
  // await page.getByRole('button', { name: '...' }).click();

  // Then: <expected result from tests.md>
  // await expect(page).toHaveURL('/...');
  test.skip(true, 'Implement from tests.md');
});
