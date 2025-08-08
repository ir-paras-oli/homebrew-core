class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.276.tar.gz"
  sha256 "58198f23c6cf5445c4abef57448d633549df3ef86e8a8368d1b5453c4bc43871"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18e5ece379d4689f260f9e59748c44fd8e113928c6da4ff841773407af4efda8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18e5ece379d4689f260f9e59748c44fd8e113928c6da4ff841773407af4efda8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18e5ece379d4689f260f9e59748c44fd8e113928c6da4ff841773407af4efda8"
    sha256 cellar: :any_skip_relocation, sonoma:        "dff6234ac4fee571379bac34f039138d0e4d16ace0f87b7fe45610c939c7c3c5"
    sha256 cellar: :any_skip_relocation, ventura:       "dff6234ac4fee571379bac34f039138d0e4d16ace0f87b7fe45610c939c7c3c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c347636ebd158556231cec9ad6bc72fa7474df4c71bc39f46422deecd9087312"
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
