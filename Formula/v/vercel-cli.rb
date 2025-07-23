class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.5.3.tgz"
  sha256 "2457901b03aa0a70a261c65869684f0b1e20737c19c56432e7c64868c20eec8b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36748baae1b93722dd34f523a22e4b05cfd770cb297d0661a62320245c0f4179"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36748baae1b93722dd34f523a22e4b05cfd770cb297d0661a62320245c0f4179"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36748baae1b93722dd34f523a22e4b05cfd770cb297d0661a62320245c0f4179"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c2cb1ea116832b9c1a3247716e7894969d183d8eb4341193c30543ad8579b83"
    sha256 cellar: :any_skip_relocation, ventura:       "8c2cb1ea116832b9c1a3247716e7894969d183d8eb4341193c30543ad8579b83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ee3e971337e68002b4364a731c63f7ac8c7f5608ff0994717cf49aad857f47b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eb18e5c5008684edcaa4cb09ecf8ae606074768d9f3d31946d41711149be640"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
