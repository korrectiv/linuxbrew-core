class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      :tag      => "v1.1.14",
      :revision => "874754dea69fbcf38d1441e4e5ee002704ab50c6"
  head "https://github.com/openshift/source-to-image.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any_skip_relocation
    sha256 "179ed06aa8cee8c8c7c6b8658eed696359170116c2ac366dadfaf086d533b033" => :mojave
    sha256 "a315100e844a70c78cf11eae24c70ff663f239fe79274da5b99223fbe6081a87" => :high_sierra
    sha256 "02ffcf2849f2051b0a7355b626ca06b2b2560ce09f68fff64f6b7a79966c750b" => :sierra
    sha256 "affb12d302fff61a4f282dd8bc668481d19479299393b9a91ef6ad4a7e4a1be1" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    # Upstream issue from 28 Feb 2018 "Go 1.10 failure due to version comparison bug"
    # See https://github.com/openshift/source-to-image/issues/851
    inreplace "hack/common.sh", "go1.4", "go1.0"

    system "hack/build-go.sh"
    bin.install "_output/local/bin/#{OS.mac? ? "darwin" : "linux"}/amd64/s2i"
  end

  test do
    system "#{bin}/s2i", "create", "testimage", testpath
    assert_predicate testpath/"Dockerfile", :exist?, "s2i did not create the files."
  end
end
