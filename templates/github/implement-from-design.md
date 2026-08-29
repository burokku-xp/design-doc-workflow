---
name: 設計に基づく実装
about: 承認済み設計書から実装を行う
labels: implementation
---

## 要件

REQ-xxx: <!-- 要件タイトル -->

## 設計書参照（読み取り専用）

| 種別 | 参照 |
|------|------|
| 機能設計 | `docs/design/<project>/features/<feature-id>/functional.md` |
| API | `.../api.md` |
| 層設計 | `.../layers.md` |
| 画面 | `.../screens.md` |
| コンポーネント | `.../components.md` |
| フロー | `.../flows.md` |
| テスト | `.../tests.md` |

## 実装ルール

- 通常: `docs/design/` は参照のみ
- **軽微な調整**: 人間が依頼した場合、同じ feat PR 内で設計書の該当行も更新可（PR に「仕様調整」記載）
- 仕様と実装が食い違う場合はこの Issue にコメントで報告
- **大きな変更**（REQ/API/画面フロー）は別 design PR

## Epic

Relates to #<!-- epic-number -->

## Cloud Agent

このIssueをコンテキストに「設計書を参照して実装して」と指示する。
