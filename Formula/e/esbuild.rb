class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.25.7.tar.gz"
  sha256 "b972ae207f89a8e60b1972a8db7cc87816fdf56b7a8818c4dd3189041f6956b4"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "def9c6f3a7a196fc3ccffd8a1c27b5e5fab381da1c565043b02e7abd5129c263"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "def9c6f3a7a196fc3ccffd8a1c27b5e5fab381da1c565043b02e7abd5129c263"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "def9c6f3a7a196fc3ccffd8a1c27b5e5fab381da1c565043b02e7abd5129c263"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2424ffe2b9bcec86e091f8a8acc07d1c49d3d3f6c57eac0b0476c08a3ed019c"
    sha256 cellar: :any_skip_relocation, ventura:       "d2424ffe2b9bcec86e091f8a8acc07d1c49d3d3f6c57eac0b0476c08a3ed019c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71063506341f68a9825a5611b05820b865680402fb031d85014efd891d6e9e2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "992f20fbd53ce5a56a46d6401c8b9c3a909f4ed3417c418b90306ace05e78b0e"
  end

  depends_on "go" => :build
  depends_on "node" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/esbuild"
  end

  test do
    (testpath/"app.jsx").write <<~JS
      import * as React from 'react'
      import * as Server from 'react-dom/server'

      let Greet = () => <h1>Hello, world!</h1>
      console.log(Server.renderToString(<Greet />))
      process.exit()
    JS

    system Formula["node"].libexec/"bin/npm", "install", "react", "react-dom"
    system bin/"esbuild", "app.jsx", "--bundle", "--outfile=out.js"

    assert_equal "<h1>Hello, world!</h1>\n", shell_output("node out.js")
  end
end
