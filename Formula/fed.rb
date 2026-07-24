class Fed < Formula
  desc "Run native apps and Docker dependencies as an isolated dev stack per Git worktree"
  homepage "https://github.com/service-federation/fed"
  version "7.6.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v7.6.4/fed-aarch64-apple-darwin.tar.xz"
      sha256 "16e2dc74bd2441e042b9b576b3413811d5be881550062d670f8a7a01a76a11ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v7.6.4/fed-x86_64-apple-darwin.tar.xz"
      sha256 "b7892e3af2c5aff26504f3e22218309070354fb29cc0fe88f66f9f8c17006166"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v7.6.4/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e1307439fc308fe337e1bdc444161ce8e1be35d8b1ef1c2f4701087e83532608"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v7.6.4/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3e6527a47eb7011eadd21baec412138159df34938530f67792d963a068180efc"
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
