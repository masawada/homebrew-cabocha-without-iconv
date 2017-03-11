class CabochaWithoutIconv < Formula
  desc "Yet Another Japanese Dependency Structure Analyzer"
  homepage "https://taku910.github.io/cabocha/"
  url "https://github.com/masawada/cabocha/archive/0.69.tar.gz"
  sha256 "4630237c0f8db791a1da3f4b2da42c1b2e27fa9257025ec7ad79b7935ebffaa0"

  bottle do
    sha1 "c6d6a98dedfe7466c454101174b3d5cbc2752f9b" => :yosemite
    sha1 "de55a785d8dcce5696a36f69b67168c913405259" => :mavericks
    sha1 "40106c50d68d5bd03941946378679ff490ae679a" => :mountain_lion
  end

  depends_on "crf++"
  depends_on "mecab"

  # To see which dictionaries are available, run:
  #     ls `mecab-config --libs-only-L`/mecab/dic/
  depends_on "mecab-ipadic" => :recommended
  depends_on "mecab-jumandic" => :optional
  depends_on "mecab-unidic" => :optional

  option "charset=", "choose default charset: EUC-JP, CP932, UTF8"
  option "posset=", "choose default posset: IPA, JUMAN, UNIDIC"

  def install
    inreplace "Makefile.in" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags
      s.change_make_var! "CXXFLAGS", ENV.cflags
    end

    charset = ARGV.value("charset") || "UTF8"
    posset = ARGV.value("posset") || "IPA"
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-charset=#{charset}
      --with-posset=#{posset}
      --without-libiconv-prefix
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    result = `echo "CaboCha はフリーソフトウェアです。" | cabocha | md5`.chomp
    assert_equal "a5b8293e6ebcb3246c54ecd66d6e18ee", result
  end
end
