class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.20.2.tar.gz"
  sha256 "8b295378d4b2d3fed4f0df6d4d5d6aa712082729334848f89f776a8fec912f97"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce84010d590a56e5451f2ff92fbdcf7a7cad6c883f11cfb16d8d6dfa2f19ce94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce84010d590a56e5451f2ff92fbdcf7a7cad6c883f11cfb16d8d6dfa2f19ce94"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce84010d590a56e5451f2ff92fbdcf7a7cad6c883f11cfb16d8d6dfa2f19ce94"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8457652a1ef2831b8d66e5cf3de4a425a3ce1a6f97a0a3ed752a4cd10f3c471"
    sha256 cellar: :any_skip_relocation, ventura:       "b8457652a1ef2831b8d66e5cf3de4a425a3ce1a6f97a0a3ed752a4cd10f3c471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bf0a1f35d1cfed5cad23f6a32d8383f3541fcd740c0e2b57d06cb4f15d5d0f7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/lego"
  end

  test do
    output = shell_output("#{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1
    )
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
