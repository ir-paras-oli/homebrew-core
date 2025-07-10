class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  url "https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "98db53c7a23a20e4cc392a1dad7200b18674ccb1a50c93c5bb6654d2d63d7212"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6a6f718cc1d08a6a22dc7b26ad189455304b1836d53b2996b99559c0d0dd7b30"
    sha256 cellar: :any,                 arm64_sonoma:  "e940f66f483c2ee3d9927e366c996fbdefc88d07ae96f28a73ee7a7608161524"
    sha256 cellar: :any,                 arm64_ventura: "1d1308b7d2fc60023a182b0e923b9c6103a59024deaebe3cd4c9a3615e09b377"
    sha256 cellar: :any,                 sonoma:        "ed32b92a12956f47226417e55fac7b3a2e2c8420f0d6af24e30eb27afe55caea"
    sha256 cellar: :any,                 ventura:       "e0f0ebb1e97c69bb688f3a07689c378df421ab32b256c952802aab19531ddf29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34f90f13c038c2eacbd546984779ea373765f6a7fca20d6509c11598b81da8f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e07c4c40d4e594bff45eb0611e2a4580a5b3104a9bcb7c9c35b8686e5908964"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sprocket --version")
    (testpath/"hello.wdl").write <<~WDL
      version 1.2

      task say_hello {
        input {
          String greeting
          String name
        }

        command <<<
          echo "~{greeting}, ~{name}!"
        >>>

        output {
          String message = read_string(stdout())
        }

        runtime {
          container: "ubuntu:latest"
        }
      }
    WDL

    expected = <<~JSON.strip
      {
        "say_hello.greeting": "String",
        "say_hello.name": "String"
      }
    JSON

    assert_match expected, shell_output("#{bin}/sprocket inputs --name say_hello #{testpath}/hello.wdl")
  end
end
