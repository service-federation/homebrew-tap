class Fed < Formula
  desc "Orchestrate your local dev stack from one config file"
  homepage "https://github.com/service-federation/fed"
  version "4.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v4.1.0/fed-aarch64-apple-darwin.tar.xz"
      sha256 "1e523ea216acc0fd77f8708999ebbb4270a228a918bd396b41a88e1faf899025"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v4.1.0/fed-x86_64-apple-darwin.tar.xz"
      sha256 "4f41c61fa7d23200dad57aa22703be0ea95a75afe6ef04ed00c7f4b1311c26f4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v4.1.0/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e5f63896d4d160e407f9adc30765bb03074354f172971fe72191d0e8da651384"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v4.1.0/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "58a0c0b2b7637025cdad3bc64d39e69adbcf08601c3bf52abf36314676ed4170"
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
