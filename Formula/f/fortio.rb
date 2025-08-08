class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.70.0",
      revision: "ce236e81d8c104b69266f00f0adf7867116cea64"
  license "Apache-2.0"
  head "https://github.com/fortio/fortio.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8f7a64a338be45c91b18965388d8821989e238e66652e430c8531acef15405e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8f7a64a338be45c91b18965388d8821989e238e66652e430c8531acef15405e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8f7a64a338be45c91b18965388d8821989e238e66652e430c8531acef15405e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8286ab681411faf7cdedfd5b640650459a9a7465f001978bcf4e131afc107e9a"
    sha256 cellar: :any_skip_relocation, ventura:       "8286ab681411faf7cdedfd5b640650459a9a7465f001978bcf4e131afc107e9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a42ab0f0283490a5d66939bfbcf0e7537ecdc43d4427fc7be22d64f026d3b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "064b7d674d8ab2b08412222fc44d9941c6fd1abbb24f16d53bf739ea433511e4"
  end

  depends_on "go" => :build

  def install
    system "make", "-j1", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}/fortio",
      "BUILD_DIR=./tmp/fortio_build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version")

    port = free_port
    begin
      pid = fork do
        exec bin/"fortio", "server", "-http-port", port.to_s
      end
      sleep 2
      output = shell_output("#{bin}/fortio load http://localhost:#{port}/ 2>&1")
      assert_match(/^All\sdone/, output.lines.last)
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end
