class Fed < Formula
  desc "Run native apps and Docker dependencies as an isolated dev stack per Git worktree"
  homepage "https://github.com/service-federation/fed"
  version "7.9.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v7.9.2/fed-aarch64-apple-darwin.tar.xz"
      sha256 "8b48ed0761fbec153758eb7c428b19c59f193d98590835841f87506df7a20b7c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v7.9.2/fed-x86_64-apple-darwin.tar.xz"
      sha256 "83ecfd3bcaa2bbcc04f2497e58a3654a36434be877f73acbdea25ffd287141b6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v7.9.2/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e547f219226b34470acea5798641dc50f375348326117847d882eb0c6f4b391a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v7.9.2/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d801542ab906468e4b5c3fad5b6ff9ce42fd5ffaf40777cef9df0082e42010ff"
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
