class Fed < Formula
  desc "Run native apps and Docker dependencies as an isolated dev stack per Git worktree"
  homepage "https://github.com/service-federation/fed"
  version "8.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v8.3.2/fed-aarch64-apple-darwin.tar.xz"
      sha256 "c1c7ea32e2670847a7833b3f6a21bed172fc9bea6ec93fc61aac66a001d5c592"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v8.3.2/fed-x86_64-apple-darwin.tar.xz"
      sha256 "2c413efe3f142580e444bfdbba2546e858aeb5a22fd209a5f7190df58c2aadad"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v8.3.2/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ac8e4d8671dc69d9376868b430cad8d1a1f3836d6a186e5981a64bb197241cac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v8.3.2/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "402ee0a90e791f3f2501296d1e990a058110f9aa0d7b74102ffe75ef7c97e996"
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
