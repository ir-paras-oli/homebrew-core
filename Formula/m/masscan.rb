class Masscan < Formula
  desc "TCP port scanner, scans entire Internet in under 5 minutes"
  homepage "https://github.com/robertdavidgraham/masscan/"
  url "https://github.com/robertdavidgraham/masscan/archive/refs/tags/1.3.2.tar.gz"
  sha256 "0363e82c07e6ceee68a2da48acd0b2807391ead9a396cf9c70b53a2a901e3d5f"
  license "AGPL-3.0-only"
  head "https://github.com/robertdavidgraham/masscan.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ba24e0d2c22cbe2291a6e872a1f5d79df7c69922b0cebdbe0864c1caaa664b72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed9e05609c9f31867e5da2a9d10eebf62ca405613ff9a11ea82307871b8954f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d67db10c93bcd8154956c4165289fbc04edce1b1d63a65af983150d9fafbcf43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba6a70814b1e311a2b817fd79e7d9a70657ceb74be1691215802a4470ca3be87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b99bf991011be4ee7d76fe43aa000159f0665b888a0cbc7c4d528d102a3daa67"
    sha256 cellar: :any_skip_relocation, sonoma:         "111509ba581461f2011aa8a65245b1deb60aeaad79ab4459f9c6978b4005604c"
    sha256 cellar: :any_skip_relocation, ventura:        "ff1b10ddec63626516bc7ae647b67524f975d77a52d1dbf93df9c32a09fe77c3"
    sha256 cellar: :any_skip_relocation, monterey:       "80601cda78b927edb63ae9e0a6b15bb9aa7d621b793d7a6cfa094a0465e66070"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d21dd16d333a573d7146d13c31dea07df5c72fcfe137af338e6f7722b393dbe"
    sha256 cellar: :any_skip_relocation, catalina:       "a77ea3fd36501d9a0d0398e585f1d30fd64163ca378e6af9660601a10e1ddce3"
    sha256 cellar: :any_skip_relocation, mojave:         "19def74a8381541e80c530a5f0599bc92f067ac3e211ecc173afbbb0aee72752"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d4a80f8db6ca9a32ba4d160d4165b4ffd0dd8a86f3246724a2c4220288d35c64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9fe1b11c5d18f102a83a6497972a7e49298f856adc260f83ac7a3d406824887"
  end

  def install
    system "make"
    bin.install "bin/masscan"
  end

  test do
    assert_match "ports =", shell_output("#{bin}/masscan --echo")
  end
end
