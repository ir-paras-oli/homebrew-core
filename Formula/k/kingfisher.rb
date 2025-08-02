class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "ed7241fb98d5477a99c803a6473671c8b0e8cb46eb818c91888f99a1555d9635"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b7847d1f20dd592c178636e1ca49e49e40a5a8806aa6fb680df9c1265366f10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e0dc483dbf2d3ae144e6ad03acd9c6f45754aea3827d0051350797f3af44b13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "554c0ff4992cec5880fa2413480830307390c268a1a448b41d77b8ce112ac45c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dd3c2f9529a1415b021dcfb31024c614ed9723ddf0c99bc888ee91ecef5d057"
    sha256 cellar: :any_skip_relocation, ventura:       "4a02e0480720492a85edfdfb40c9f380ce6462088b37b8eeb8ffc38cfb32dd1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "854297b5b405f22cc4136b7d7aa7a4924b0146dfa1b5b455b413ff47382e8450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c436810acd3c6af2bc31af4db88c2e7a6911e1984ca5b4ffedc8af37195d2863"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
