class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar/archive/0.5.1.tar.gz"
  sha256 "f2ade7c0b5d362eb4b9e51ca4faa7a8a200f08a62a7104c0d61cab1f6ea18b09"
  head "https://github.com/glandium/git-cinnabar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9c5be58e2f01142e7161b42274e9e71c3d11abb4bb51b55d30a3ed78abd71c8" => :mojave
    sha256 "850ccdd7ac691bcaeabeeb2095005086ff8328229ca55ac17fff018b895d5088" => :high_sierra
    sha256 "6d993a4b947aee4ce6770d4b0eebe2529ee112e5cc4bdbecf5e02a4b73956f01" => :sierra
    sha256 "bf1990faaefcad03b04ecca6c5b635f54ce55d86ccd04eee48ac16752c21edf0" => :x86_64_linux
  end

  depends_on "mercurial"
  depends_on "curl" unless OS.mac?

  conflicts_with "git-remote-hg", :because => "both install `git-remote-hg` binaries"

  def install
    system "make", "helper"
    prefix.install "cinnabar"
    bin.install "git-cinnabar", "git-cinnabar-helper", "git-remote-hg"
    bin.env_script_all_files(libexec, :PYTHONPATH => prefix)
  end

  test do
    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
    assert_predicate testpath/"hello/hello.c", :exist?,
                     "hello.c not found in cloned repo"
  end
end
