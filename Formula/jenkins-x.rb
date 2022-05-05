class JenkinsX < Formula
  desc "Automated CI+CD for Kubernetes"
  homepage "https://jenkins-x.io/"
  url "https://github.com/jenkins-x/jx.git",
      tag:      "v3.2.292",
      revision: "7ffcc32b2db39d445bf331241942d91e70f4f6d6"
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

    ns_output = shell_output("#{bin}/jx ns jx 2>&1", 1)
    assert_match "error: namespaces \"jx\" not found", ns_output

    version_output = shell_output("#{bin}/jx version 2>&1")
    assert_match "version:", version_output
    if build.stable?
      revision = stable.specs[:revision][0..8]
      assert_match revision.to_s, version_output
    end
  end
end
