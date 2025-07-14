class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.7.8.tar.gz"
  sha256 "0109ae9b8aff0cb6da590db731916ada80c07d1921c8dee9fcec918b488f9258"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81338a157f8bd1d94364d55003ea1ddcb56661ecf418fd8c67af467993e23d82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7936ef75d6f71857bf57778253745f1ab4935a1eb89532d7d2ce978145f539c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72be9b45381c3f47d5a65f24159ae86135ec3ed117be44ec05b360d732c06a99"
    sha256 cellar: :any_skip_relocation, sonoma:        "1eb2cb859a0e829aab095c9041929786846f922c4fda85fc2fc0863829a7c385"
    sha256 cellar: :any_skip_relocation, ventura:       "edc0671690fc45197f024d4b00f33aa640b0c1fe601057c4307ba7e0e4eeff64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f65a8cc85c76c3e22516d7e996c594a4f5ca0c2536b66bd1af7862759fce417e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71d9339d30ca47d270586bb0c14a4f40137759e8f5a3c0e5c16478e4a01bac8d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completions/mise.bash" => "mise"
    fish_completion.install "completions/mise.fish"
    zsh_completion.install "completions/_mise"
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")
  end
end
