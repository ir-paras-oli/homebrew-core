class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.3.0.tgz"
  sha256 "4cc08d0ec4e464d18f1d02aa33a7fb7a22bf1f56f82aebd47912571a5225fe8e"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "b0efacb2355b3e80b2543d82fad61d5fd9b8fbcf90dfe16448ca395a8d12ce15"
    sha256                               arm64_sonoma:  "b0efacb2355b3e80b2543d82fad61d5fd9b8fbcf90dfe16448ca395a8d12ce15"
    sha256                               arm64_ventura: "b0efacb2355b3e80b2543d82fad61d5fd9b8fbcf90dfe16448ca395a8d12ce15"
    sha256 cellar: :any_skip_relocation, sonoma:        "881a5bfc942e2ebc58679276b1b72647a3d161b1a9168d8eb00c43a2ad63886f"
    sha256 cellar: :any_skip_relocation, ventura:       "881a5bfc942e2ebc58679276b1b72647a3d161b1a9168d8eb00c43a2ad63886f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab4e2818b93f1816247bb9842ab10cf8f9672bd0bcbe50ba1a58476b791a260b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e6a90ed0cc652c87b7cf5d6a5aaf294ef0d10ba5435896382a75e3d8f44790d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    (testpath/"test").mkpath
    cd testpath/"test" do
      system "git", "init"

      # Test backlog init command requires interactive input
      require "open3"
      Open3.popen3("#{bin}/backlog", "init", "test") do |stdin, _stdout, _stderr, wait_thr|
        stdin.puts "y"
        sleep 1
        stdin.puts "y"
        sleep 1
        stdin.puts "n"
        sleep 1
        stdin.puts "n"
        sleep 1
        stdin.puts "\n"
        sleep 1
        stdin.puts "\n"
        sleep 1
        stdin.close
        wait_thr.value # Wait for process to complete
      end

      assert_path_exists testpath/"test/backlog"
    end
  end
end
