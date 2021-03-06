class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/5.4.0/mlr-5.4.0.tar.gz"
  sha256 "d9a7ed10a1a5e71082c33d489f77ab9caba6e6c4f9bf0f6c3958201b64974f7e"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any_skip_relocation
    sha256 "a2a049c66f1a1f3d8bb14a316afa5624c290ddca8a5723417fe7bfb0b682d62e" => :mojave
    sha256 "dfe0d02b8fe42510d2637a6016ac7527b7e7fef981b6677f9171236780ffd05b" => :high_sierra
    sha256 "2d28eda0033407a1ca4b191d67b9e742d16d0b7af106525062ab5bc4151eb6a8" => :sierra
    sha256 "7f6690b11762a4d6fcb9f42a9dbf142716726a4c70ea9aafa1791f7aa9041508" => :x86_64_linux
  end

  head do
    url "https://github.com/johnkerl/miller.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "flex" => :build unless OS.mac?

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                          "--disable-dependency-tracking"
    system "make"
    # Time zone related tests fail. Reported upstream https://github.com/johnkerl/miller/issues/237
    system "make", "check" unless OS.linux? && ENV["CI"]
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
      4,5,6
    EOS
    output = pipe_output("#{bin}/mlr --csvlite cut -f a test.csv")
    assert_match /a\n1\n4\n/, output
  end
end
