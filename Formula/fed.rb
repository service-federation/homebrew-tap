class Fed < Formula
  desc "Orchestrate your local dev stack from one config file"
  homepage "https://github.com/service-federation/fed"
  version "5.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v5.1.1/fed-aarch64-apple-darwin.tar.xz"
      sha256 "0a6172f461118a7882d08a82a0db9a5061e0f85aab33377b5b69fc93f10ff9f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v5.1.1/fed-x86_64-apple-darwin.tar.xz"
      sha256 "b460fcf0ccc5648c7653833ce3dcfa02bffc6bd5e1c0107a24b360952a40c584"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v5.1.1/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "be8f8917b7038b8651d62d7df730ffa8c67b29881e3d3abd78db7d21fed5198d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v5.1.1/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c67608de89de379dba583013f22aac96366510b6c9f408264a7bffb11e3006dc"
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
