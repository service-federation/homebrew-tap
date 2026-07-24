class Fed < Formula
  desc "Run native apps and Docker dependencies as an isolated dev stack per Git worktree"
  homepage "https://github.com/service-federation/fed"
  version "7.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v7.5.0/fed-aarch64-apple-darwin.tar.xz"
      sha256 "b4d313e286d25ef74441a7261d7063955f361c3e7b08aff54d704379e3a749d7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v7.5.0/fed-x86_64-apple-darwin.tar.xz"
      sha256 "2ea2aed83d1bf242b796224388979ebc20ba33185a6bd70fdb201ab6787eb897"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v7.5.0/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0538c668795f1f67cb092919bc169e6c2a9d6ef9a8ec2b3cd2e86ba64755288d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v7.5.0/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "95b3a21f9fdce07ac60dbf3a14324f5a2f0abd65e14a787781201d4061da622d"
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
