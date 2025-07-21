class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.29.8.tar.gz"
  sha256 "371bb686df15b1a46ebd4797cadaeaedf04825a944bb29729a536d68b17596b9"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/apko.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ca3e88401a87441f6beba4cba67fdd45426f98e005ccc128a75d495a15cb7d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83b92ac612332e69f5c0a25a301f6d012569a72280d0e4112470dab05932b544"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14a61818164b35f9e078b07449acd71851cf23a9666088d3a3b5f2b1df6ffe85"
    sha256 cellar: :any_skip_relocation, sonoma:        "e14db62be8771adae514cc4745c77d868fc2b3549c397fc52fb5b8e602ed2a8c"
    sha256 cellar: :any_skip_relocation, ventura:       "7d0f91eebfa90deac46e79a08132cd0e8d9a5629cbc5cf8ed21b2f667ef1262d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a945d5ea866ef6b30c8a6d10b20476eea19a302197cfe1ce7fc9ba877e61cf28"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=brew
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"apko", "completion")
  end

  test do
    (testpath/"test.yml").write <<~YAML
      contents:
        repositories:
          - https://dl-cdn.alpinelinux.org/alpine/edge/main
        packages:
          - alpine-base

      entrypoint:
        command: /bin/sh -l

      # optional environment configuration
      environment:
        PATH: /usr/sbin:/sbin:/usr/bin:/bin

      # only key found for arch riscv64 [edge],
      archs:
        - riscv64
    YAML
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_path_exists testpath/"apko-alpine.tar"

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end
