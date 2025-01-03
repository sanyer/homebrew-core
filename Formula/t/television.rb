class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.8.3.tar.gz"
  sha256 "d6260a239bafd5d8e9ea791cfaafb4e338a75209e469dbb4c8ad924b69792115"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4048c3c23640da1d31e84a3c21e4e8951e1145c417edee44202e62698af14890"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce55294e1661110c868dbfce52e5f7c6da1aa93d312e9d8ce805bf182680fcf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "339bca3183495b3e5cd2285813d66ee9f99ec8ccab5bcdbc5eeafc78a5951501"
    sha256 cellar: :any_skip_relocation, sonoma:        "64c710e85da5392a73f640af8cd4af1124c479c9a6a3d7fde3b663ab43264e86"
    sha256 cellar: :any_skip_relocation, ventura:       "7a9976f5905c663e7a49dd36fb1acb2a8716adcdb275c41c71dae7aa6ea3d6c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eaacdd7668a3f2706813bcfa05f1b958159318dca30e3e0d4aebce3e29de923"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"tv", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "preview", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
