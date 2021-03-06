class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v2.0.2.tar.gz"
  sha256 "110a271298223251005266b915432196b340f8540de1b4c1489973537d9b3bb1"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any_skip_relocation
    sha256 "32f83002dbc98f67163558a156ed7a8b651062e4890a46e2bd9de465db85d4a6" => :mojave
    sha256 "e6ca63d7881f92f2ca58924badb97ba8abf6dfb07a1c191afb860eb9729bd808" => :high_sierra
    sha256 "cd5f23460d45df867b2067ee650d55ce8f4bb16e7d248b980e26cdcdde0fe9b4" => :sierra
    sha256 "34505f09281be8ad1d5a0ba3e0e1e6cc4de99167cb2856189c1d042a5686f58a" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/DarthSim/overmind").install buildpath.children
    system "go", "build", "-o", "#{bin}/overmind", "-v", "github.com/DarthSim/overmind"
  end

  test do
    expected_message = "overmind: open ./Procfile: no such file or directory"
    assert_match expected_message, shell_output("#{bin}/overmind start 2>&1", 1)
    (testpath/"Procfile").write("test: echo 'test message'")
    expected_message = "test message"
    assert_match expected_message, shell_output("#{bin}/overmind start")
  end
end
