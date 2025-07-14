class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.57.0.tar.gz"
  sha256 "7ebd8c3c97fd76d23b202495930cdbbd406a6ea79cac359f4997dc2bc80d4dcd"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71629b58d803952cef1a31bd11c6d1a2e82903065786e802eb89da3dd61eb6c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d72e24e2eacf52cae5236426ba43762c1518e610d924b0345b639db340e711a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae63524d50917cbe0dcb00fb2f015829ef95750652e24d3ccc63d2ccd0101bb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "05bc1a758f63489015bac07b06f0fd51d81b7a28c3384dc6a5bdfae4287e22c5"
    sha256 cellar: :any_skip_relocation, ventura:       "fe48bbb417bdce1d86882eaea4c26a88229cc80434bf072b0f53a391e859169a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a90e18a8f8aed7d4600c531496589067a60841188b7aadc2b8ae00165146b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dfca9279c81efd21ea33396b4ad62d2762b30eebad7d36fde09778d4cabde9a"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~SWIFT
      struct Potato {
        let baked: Bool
      }
    SWIFT
    system bin/"swiftformat", "#{testpath}/potato.swift"
  end
end
