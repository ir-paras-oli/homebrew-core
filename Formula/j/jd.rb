class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "3afa5f0b38efd9eb36154c7a75f5731ee66f3c7a1f580b236eabccb65cb47352"
  license "MIT"
  head "https://github.com/josephburnett/jd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3cf382ecb26b9288dedab8eb85c1464f891c81f8f90cc1f22f96b5cd6774f7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3cf382ecb26b9288dedab8eb85c1464f891c81f8f90cc1f22f96b5cd6774f7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3cf382ecb26b9288dedab8eb85c1464f891c81f8f90cc1f22f96b5cd6774f7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c85651e38649266b6b2f7226301f614b67b34603b607d0d71fdfa74507d8a78b"
    sha256 cellar: :any_skip_relocation, ventura:       "c85651e38649266b6b2f7226301f614b67b34603b607d0d71fdfa74507d8a78b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8300e45ccd04f69d153ef2f0a5c1482ff2f7c03a7507b78dbbf2a08a049d673"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./v2/jd/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jd --version")

    (testpath/"a.json").write('{"foo":"bar"}')
    (testpath/"b.json").write('{"foo":"baz"}')
    (testpath/"c.json").write('{"foo":"baz"}')
    expected = <<~EOF
      @ ["foo"]
      - "bar"
      + "baz"
    EOF
    assert_equal expected, shell_output("#{bin}/jd a.json b.json", 1)
    assert_empty shell_output("#{bin}/jd b.json c.json")
  end
end
