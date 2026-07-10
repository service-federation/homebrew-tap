class Fed < Formula
  desc "Orchestrate your local dev stack from one config file"
  homepage "https://github.com/service-federation/fed"
  version "5.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v5.2.0/fed-aarch64-apple-darwin.tar.xz"
      sha256 "84a80da3fbbfaa556b5e7929a5fec340d18f7087b47cd6237aa95aa7712d1e6e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v5.2.0/fed-x86_64-apple-darwin.tar.xz"
      sha256 "9a5169d5dc5e7a54017a6f58f5ea638a44be4708d0cd098b6af261272aff0df4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v5.2.0/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1883aaa042714e1852bc77cc607b3995161d8df9d374696bcc01d2ecdf629e68"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v5.2.0/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "44912768813223a76dd742ca422baacb6f87845c88bcd07717399d4643cc3d27"
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
