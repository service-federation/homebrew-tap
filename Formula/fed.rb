class Fed < Formula
  desc "Run native apps and Docker dependencies as an isolated dev stack per Git worktree"
  homepage "https://github.com/service-federation/fed"
  version "7.9.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v7.9.1/fed-aarch64-apple-darwin.tar.xz"
      sha256 "8571c8a5cd784bfd293ff0b3bc615bf3106ce687f493ad7694b89df7274cbbc2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v7.9.1/fed-x86_64-apple-darwin.tar.xz"
      sha256 "d68dc6b804702179c3b46f8c5065b99ec76790d5aa8d89bbd70c1531f9f00d5e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v7.9.1/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ea17afc9e1523b9e7d1599e5b63fe267998d71101269b046423b89fb0547aefc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v7.9.1/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6ae6ecf8b1922eeda9df6eab54f199e6446f0c260c9dd74999a4a5a02cafb3b4"
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
