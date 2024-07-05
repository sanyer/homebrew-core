require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.77.tgz"
  sha256 "b7dc45125e666c1780013d8349ceb1d01a55828c7aa981a264fea3631bd9f492"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6ba8cd38adbf5979572d54ab0fbc652e0a89e1e08a892cfb42c13a697be4cb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6ba8cd38adbf5979572d54ab0fbc652e0a89e1e08a892cfb42c13a697be4cb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6ba8cd38adbf5979572d54ab0fbc652e0a89e1e08a892cfb42c13a697be4cb0"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6ba8cd38adbf5979572d54ab0fbc652e0a89e1e08a892cfb42c13a697be4cb0"
    sha256 cellar: :any_skip_relocation, ventura:        "e6ba8cd38adbf5979572d54ab0fbc652e0a89e1e08a892cfb42c13a697be4cb0"
    sha256 cellar: :any_skip_relocation, monterey:       "e6ba8cd38adbf5979572d54ab0fbc652e0a89e1e08a892cfb42c13a697be4cb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c4696f908be3951ea5a2be95a75a3ab86b3042a0526ba809ea736887ff267a4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove x86 specific optional feature
    node_modules = libexec/"lib/node_modules/whistle/node_modules"
    rm_f node_modules/"set-global-proxy/lib/mac/whistle" if Hardware::CPU.arm?
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
