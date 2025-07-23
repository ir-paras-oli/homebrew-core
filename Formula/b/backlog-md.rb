class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.5.5.tgz"
  sha256 "ce76b100a6ede603266bdde90235a3075e832d361e4fe66caa5bca7d934e8537"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "bd3f1cc416689237d874c8ba701acb493c11d42403a3970647ded2b7821774f7"
    sha256                               arm64_sonoma:  "bd3f1cc416689237d874c8ba701acb493c11d42403a3970647ded2b7821774f7"
    sha256                               arm64_ventura: "bd3f1cc416689237d874c8ba701acb493c11d42403a3970647ded2b7821774f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bff053a37e4a6b51e68eb1b68f5f64318eb8faae5fe7a4f9d18dc92b92c3e07"
    sha256 cellar: :any_skip_relocation, ventura:       "5bff053a37e4a6b51e68eb1b68f5f64318eb8faae5fe7a4f9d18dc92b92c3e07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18cc2d6032fa452b50746c46af99226f764188c53925afcd1aa46a18799cbbac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b18c4c2f24d158fec1246f5ef4b315a2544caa5fd1204ffd787f4cb144ec65d"
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
