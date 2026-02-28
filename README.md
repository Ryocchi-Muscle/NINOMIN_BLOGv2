# NINOMIN_BLOGv2

Personal blog

## 概要

単なる「ブログ」の構築に留まらず、**運用負荷（Toil）の徹底排除**と**信頼性・セキュリティのコード定義**を主眼に置いている。Git を唯一の正解（Single Source of Truth）とした GitOps モデルを実践し、スケーラブルかつ堅牢な配信基盤を最小構成で実現する。

---

## 使用技術

| カテゴリ           | 選定技術              | ADR                                                                                                      |
| :----------------- | :-------------------- | :------------------------------------------------------------------------------------------------------- |
| **Frontend**       | Astro (TypeScript)    | **Zero-JS / Islands Architecture.** 実行時負荷を最小化し、攻撃対象領域（Attack Surface）を物理的に削減。 |
| **Infrastructure** | AWS (S3 + CloudFront) | **Managed Service First.** 業界標準の CDN 配信と、OAC (Origin Access Control) によるセキュアな権限管理。 |
| **IaC**            | Terraform             | **Reproducibility.** インフラをコード化し、環境の再現性と変更履歴の透明性を担保。                        |
| **CI/CD**          | GitHub Actions        | **GitOps.** ビルド・テスト・デプロイの一連のパイプラインを自動化し、ヒューマンエラーを排除。             |
| **Package Mgr**    | pnpm                  | **Strictness.** 幽霊依存（Phantom Dependencies）を許容しない厳格な管理と、高速なビルド時間を実現。       |

---

## 主な機能

- **Automated Infrastructure (IaC):** `terraform apply` 一撃で AWS 上に最適化された配信基盤を構築。
- **GitOps Pipeline:** `main` ブランチへのプッシュをトリガーとした、静的サイト生成（SSG）と S3 同期の完全自動化。
- **Secure Edge Delivery:** CloudFront OAC を採用し、S3 への直接アクセスを遮断。エッジ側でのセキュリティガバナンスを強制。
- **Performance Optimized:** クライアントサイド JavaScript を極限まで排除し、Core Web Vitals における最高スコアを追求。

---

## ディレクトリ構成

「関心の分離（Separation of Concerns）」に基づき、アプリケーションコードとインフラ定義を物理的に分離している。

```text
.
├── .github/workflows/    # CI/CD パイプライン定義 (GitHub Actions)
├── src/                  # Astro アプリケーションソース (TypeScript)
│   ├── components/       # 再利用可能な UI コンポーネント
│   ├── layouts/          # 共通レイアウト定義
│   └── pages/            # ルーティングおよびコンテンツ定義
├── terraform/            # インフラストラクチャ定義 (IaC)
│   ├── main.tf           # AWS リソース定義 (S3, CloudFront, OAC)
│   ├── variables.tf      # 定義済み変数
│   └── outputs.tf        # デプロイ後の出力値 (CloudFront URL等)
├── public/               # 静的アセット（画像等）
├── astro.config.mjs      # Astro 設定ファイル
└── package.json          # プロジェクト定義
```
