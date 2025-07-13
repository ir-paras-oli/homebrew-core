class Stormy < Formula
  desc "Minimal, customizable and neofetch-like weather CLI based on rainy"
  homepage "https://github.com/ashish0kumar/stormy"
  url "https://github.com/ashish0kumar/stormy/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "09c775b707c1e6800f4d457f188a1956c6b2726bdf9f62701338647d804622c0"
  license "MIT"
  head "https://github.com/ashish0kumar/stormy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6e4aae17786f5f2325ffb965a50fe91a09ca073ac3ba88e4a1781440b58fae9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6e4aae17786f5f2325ffb965a50fe91a09ca073ac3ba88e4a1781440b58fae9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6e4aae17786f5f2325ffb965a50fe91a09ca073ac3ba88e4a1781440b58fae9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f954aafbda37ba4ff10bbf277d2d6c68f9b8fe507c96c1c68b4c8a6078886a6"
    sha256 cellar: :any_skip_relocation, ventura:       "7f954aafbda37ba4ff10bbf277d2d6c68f9b8fe507c96c1c68b4c8a6078886a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b9f3fc4ef0927bad3f5ecc70a786463f868278799e616dee296c1672e54eab9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Weather", shell_output("#{bin}/stormy --city London")
    assert_match "Error: City must be set in the config file or via command line flags",
      shell_output("#{bin}/stormy 2>&1", 1)
  end
end
