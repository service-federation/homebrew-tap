class Fed < Formula
  desc "Orchestrate your local dev stack from one config file"
  homepage "https://github.com/service-federation/fed"
  version "6.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v6.0.0/fed-aarch64-apple-darwin.tar.xz"
      sha256 "f9807ebe600c043f5e675b3d39a0c4ab249f073e1a3daed1a75f4507178838db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v6.0.0/fed-x86_64-apple-darwin.tar.xz"
      sha256 "735f927d8283fb6269b57e1cff6f41c2043ef57afc121216dbd4d80b7cc11469"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v6.0.0/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e98e57b7d41ceb91caec707c9a53ac7e8903e2a02f977a3f12cb510724b59ef2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v6.0.0/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bcef9ecfbed58103caf41c4044c9bc77d5e378c71780f4ec948419f78e44f616"
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
