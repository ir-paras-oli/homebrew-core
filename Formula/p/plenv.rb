class Plenv < Formula
  desc "Perl binary manager"
  homepage "https://github.com/tokuhirom/plenv"
  url "https://github.com/tokuhirom/plenv/archive/refs/tags/2.3.1.tar.gz"
  sha256 "12004cfed7ed083911dbda3228a9fb9ce6e40e259b34e791d970c4f335935fa3"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https://github.com/tokuhirom/plenv.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9ae1be5da65e151734516a4c61d65dcdf5c64895c6477a28bce5351888f57627"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f269a34269c43edc721fe59d7d6bed6740c27544de3b7936290a52644957d2da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b7e0d4973dfe5c197b36672d2d07f355d90b831b36189208c021770bfa1465d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b7e0d4973dfe5c197b36672d2d07f355d90b831b36189208c021770bfa1465d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8003aaa1404beacb1ef33010bbf1ed82abb2436e9a3764a6d5f2cac83aa085ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "b31005f49894bcd4160911f841489e89a44f7d4e6f610d96573c9e58d35d97fe"
    sha256 cellar: :any_skip_relocation, ventura:        "3cb9ef92ada0b01f97c1ccd746cd976673b8b21b0672995dbdf5fc0205aa0795"
    sha256 cellar: :any_skip_relocation, monterey:       "3cb9ef92ada0b01f97c1ccd746cd976673b8b21b0672995dbdf5fc0205aa0795"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae532487be7748372f5e4af1f5f5543ea98c2821ae63a28b85fe5a47c17734a2"
    sha256 cellar: :any_skip_relocation, catalina:       "ae532487be7748372f5e4af1f5f5543ea98c2821ae63a28b85fe5a47c17734a2"
    sha256 cellar: :any_skip_relocation, mojave:         "ae532487be7748372f5e4af1f5f5543ea98c2821ae63a28b85fe5a47c17734a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4b80e2706c6cc7af6ec145bb53a32deab34a91b0a9339ad8e16e4a6cbc7c0c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6898b01d73122d18ac80e714614e566482fdc1b8055a3ef01cc11a3c9cde503c"
  end

  depends_on "perl-build"

  def install
    prefix.install "bin", "plenv.d", "completions", "libexec"

    # Run rehash after installing.
    system bin/"plenv", "rehash"
  end

  def caveats
    <<~EOS
      To enable shims add to your profile:
        if which plenv > /dev/null; then eval "$(plenv init -)"; fi
      With zsh, add to your .zshrc:
        if which plenv > /dev/null; then eval "$(plenv init - zsh)"; fi
      With fish, add to your config.fish
        if plenv > /dev/null; plenv init - | source ; end
    EOS
  end

  test do
    assert_match(/\* system \(set by/, shell_output("#{bin}/plenv versions"))
  end
end
