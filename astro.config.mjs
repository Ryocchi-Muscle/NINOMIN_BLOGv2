// @ts-check

import mdx from "@astrojs/mdx";
import sitemap from "@astrojs/sitemap";
import { defineConfig } from "astro/config";

// https://astro.build/config
export default defineConfig({
  site: "https://d2z72kf1ui8phr.cloudfront.net/",
  integrations: [mdx(), sitemap()],
});
