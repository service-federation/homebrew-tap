class Fed < Formula
  desc "Orchestrate your local dev stack from one config file"
  homepage "https://github.com/service-federation/fed"
  version "6.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v6.3.0/fed-aarch64-apple-darwin.tar.xz"
      sha256 "426e55da0720521cca1b93d8b4996506f8890072db4d152d9a46d171b28136c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v6.3.0/fed-x86_64-apple-darwin.tar.xz"
      sha256 "5d254775b0cf6477cf2df1f9eba7d76c7b072e71a841bc516f9747aa2653378b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v6.3.0/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "af3eb6061b85468c0939515c53040d06f800342322bcc33982110ff8914e3043"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v6.3.0/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5ab3d626093e13a9cee19ea2ce7498b8590b9f0679e0c62861c43d1bdb529c1d"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "fed" if OS.mac? && Hardware::CPU.arm?
    bin.install "fed" if OS.mac? && Hardware::CPU.intel?
    bin.install "fed" if OS.linux? && Hardware::CPU.arm?
    bin.install "fed" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
