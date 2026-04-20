/** @type {import('next').NextConfig} */
const nextConfig = {
  // Enable standalone output for Docker deployment.
  // This produces a self-contained server in .next/standalone/ that includes
  // only the minimal Node.js files needed to run the app — no node_modules copy required.
  // See: https://nextjs.org/docs/app/api-reference/next-config-js/output
  output: "standalone",

  images: {
    remotePatterns: [
      {
        protocol: "https",
        hostname: "images.2dehands.com",
      },
      {
        protocol: "https",
        hostname: "twhbe.images.icas.io",
      },
    ],
  },
};

export default nextConfig;
