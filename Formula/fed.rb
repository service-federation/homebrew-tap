class Fed < Formula
  desc "Run native apps and Docker dependencies as an isolated dev stack per Git worktree"
  homepage "https://github.com/service-federation/fed"
  version "7.6.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v7.6.3/fed-aarch64-apple-darwin.tar.xz"
      sha256 "134e573e30502a33cc9d2c48671a0ee1ff2293625b862157de2c2f8d9dfd5bb8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v7.6.3/fed-x86_64-apple-darwin.tar.xz"
      sha256 "f21c3bc92d3f0897e3ee181780154cd5965e27b4ec9c665390bec5c34b0b249d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v7.6.3/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c12b0c762ece333f0cca43f9cc1834ebca72963351f4e1d8ad10ef1c59194cdc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v7.6.3/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6d5f83e6db07c68039a9d2c200983ae40327447dd3df7991e08d9f03877eb9e8"
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
