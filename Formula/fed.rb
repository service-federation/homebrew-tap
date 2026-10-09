class Fed < Formula
  desc "Run native apps and Docker dependencies as an isolated dev stack per Git worktree"
  homepage "https://github.com/service-federation/fed"
  version "8.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v8.2.0/fed-aarch64-apple-darwin.tar.xz"
      sha256 "0d21732595019799eb5d416f2dc5da2087235a31245d9894fd0aae3d358e441c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v8.2.0/fed-x86_64-apple-darwin.tar.xz"
      sha256 "29aa5a20359d310cdac82890a6e74f9a94ccdf20816613b215152424a426676d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v8.2.0/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d19092bc4d47bba5495f8366c89e1eba13daeaa8da9640fcb405e935f40e2005"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v8.2.0/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "283d3b93ac6d4655a2740da021b3a0ab7bb318fe2695c79ef9d394f5179d6b87"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "fed"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "fed"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "fed"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "fed"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
