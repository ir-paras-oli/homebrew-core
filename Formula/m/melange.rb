class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.30.2.tar.gz"
  sha256 "27889130416ab0a902193014bdb41e30767c521b3832e1cebc3c7a5996c30e23"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb7a6b2054a5a3d653a4162389d7e9d8a84f48a83d3851498cb31c7a8681a309"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdb40baa3625c343042462ba85f1ecc38997f80e8ff83e0777213136716bbf69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3bff03da18fc64f34755375321358e3dbc1a7d05748e3acf0031cd3df76fda45"
    sha256 cellar: :any_skip_relocation, sonoma:        "0315ce6c7965cd2651f964f1b98fb64d8a563bbdce7230342d7f1c31d5e713f8"
    sha256 cellar: :any_skip_relocation, ventura:       "22c74517feeac6872c1d967ef584c113041ac83ba91718ef52948e1f120371b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f09157a117e1ffddb366708e54da63fe1ec4232645730ca695a72b924eb085d"
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

    generate_completions_from_executable(bin/"melange", "completion")
  end

  test do
    (testpath/"test.yml").write <<~YAML
      package:
        name: hello
        version: 2.12
        epoch: 0
        description: "the GNU hello world program"
        copyright:
          - paths:
            - "*"
            attestation: |
              Copyright 1992, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2005,
              2006, 2007, 2008, 2010, 2011, 2013, 2014, 2022 Free Software Foundation,
              Inc.
            license: GPL-3.0-or-later
        dependencies:
          runtime:

      environment:
        contents:
          repositories:
            - https://dl-cdn.alpinelinux.org/alpine/edge/main
          packages:
            - alpine-baselayout-data
            - busybox
            - build-base
            - scanelf
            - ssl_client
            - ca-certificates-bundle

      pipeline:
        - uses: fetch
          with:
            uri: https://ftp.gnu.org/gnu/hello/hello-${{package.version}}.tar.gz
            expected-sha256: cf04af86dc085268c5f4470fbae49b18afbc221b78096aab842d934a76bad0ab
        - uses: autoconf/configure
        - uses: autoconf/make
        - uses: autoconf/make-install
        - uses: strip
    YAML

    assert_equal "hello-2.12-r0", shell_output("#{bin}/melange package-version #{testpath}/test.yml")

    system bin/"melange", "keygen"
    assert_path_exists testpath/"melange.rsa"

    assert_match version.to_s, shell_output("#{bin}/melange version 2>&1")
  end
end
