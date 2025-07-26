class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.266.tar.gz"
  sha256 "95d3d9adaeb4ae3dc67b3f9923f942690633b2b0b3b6d52664baf8360958f887"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0961d9118a7472ed4247bd903e3a6760d3aef35fe7199eaba2729d735f237475"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0961d9118a7472ed4247bd903e3a6760d3aef35fe7199eaba2729d735f237475"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0961d9118a7472ed4247bd903e3a6760d3aef35fe7199eaba2729d735f237475"
    sha256 cellar: :any_skip_relocation, sonoma:        "cad26701332e612c239ebe8bc581e94528c19d61a436848214749ef6dd61a1ac"
    sha256 cellar: :any_skip_relocation, ventura:       "cad26701332e612c239ebe8bc581e94528c19d61a436848214749ef6dd61a1ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cb828b7ae6ac55ec59548a1b063692c04262f8527bed9b4208f212619e36c85"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end
