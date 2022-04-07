class JenkinsX < Formula
  desc "Automated CI+CD for Kubernetes"
  homepage "https://jenkins-x.io/"
  url "https://github.com/jenkins-x/jx.git",
      tag:      "v3.2.287",
      revision: "a28624c634bc9bce5d9b7b11dd557397d68e6930"
  license "Apache-2.0"
  head "https://github.com/jenkins-x/jx.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" # needs GNU date
    system "make", "build"
    bin.install "build/jx"
  end

  test do
    run_output = shell_output("#{bin}/jx 2>&1")
    assert_match "Jenkins X 3.x command line", run_output

    version_output = shell_output("#{bin}/jx version 2>&1")
    assert_match "version:", version_output
    if build.stable?
      revision = stable.specs[:revision][0..8]
      assert_match revision.to_s, version_output
    end
  end
end
