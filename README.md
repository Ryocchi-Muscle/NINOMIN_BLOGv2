# NINOMIN_BLOGv2

NINOMIN_BLOGからの移行中。
現状Iacのみ構築完了。
ブログの中身は今後作成予定。

Astro製の個人ブログ。フロントエンドのビルドからAWSインフラの構築まで、全てコードで管理している。

## アーキテクチャ

```
Astro (SSG)
    ↓ pnpm build
S3 Bucket  ←  OAC (Origin Access Control)
    ↓
CloudFront (CDN / HTTPS強制)
    ↓
CloudWatch Logs (7日保持 / FinOps)
```

静的サイトをS3にホスティングし、CloudFrontをCDNとして配信する構成。S3への直接アクセスはOACで制限し、CloudFront経由のみに絞っている。

## IaC (Terraform)

インフラはすべてTerraformで管理。

```
terraform/
└── main.tf   # S3 / CloudFront / OAC / CloudWatch Logs
```

| リソース | 用途 |
| :--- | :--- |
| `aws_s3_bucket` | 静的ファイルのホスティング |
| `aws_cloudfront_origin_access_control` | S3への直接アクセスを遮断 |
| `aws_cloudfront_distribution` | CDN・HTTPS強制 |
| `aws_s3_bucket_policy` | OAC統合のバケットポリシー |
| `aws_cloudwatch_log_group` | デプロイログ（7日保持でコスト最適化） |

```sh
cd terraform
terraform init
terraform plan
terraform apply
```

## フロントエンド

- [Astro](https://astro.build/) v5 (SSG)
- MDX / Markdown
- RSS Feed / Sitemap

## セットアップ

```sh
pnpm install
pnpm dev      # 開発サーバー (localhost:4321)
pnpm build    # ./dist/ にビルド
```

## ディレクトリ構成

```
├── src/
│   ├── components/
│   ├── content/
│   │   └── blog/     # ブログ記事 (Markdown / MDX)
│   ├── layouts/
│   └── pages/
└── terraform/
    └── main.tf       # AWSインフラ定義
```
