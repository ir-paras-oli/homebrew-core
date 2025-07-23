class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.25.tgz"
  sha256 "61bea99a8aeb641d48f261be74be3b17c56db30c7b924a426b80832825350c52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9bd975065074868f290affde38ab25401b9d4ae6805a8edb7e57ee068356145c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
