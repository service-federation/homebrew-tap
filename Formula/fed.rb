class Fed < Formula
  desc "Run native apps and Docker dependencies as an isolated dev stack per Git worktree"
  homepage "https://github.com/service-federation/fed"
  version "7.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v7.7.0/fed-aarch64-apple-darwin.tar.xz"
      sha256 "28606247387fe178c49c95c24fc6db7cc1721a6149dc0206f2201deab5190983"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v7.7.0/fed-x86_64-apple-darwin.tar.xz"
      sha256 "0557d5440329e6c964911e6f6414d5f4bbc6c4f26130c67783590e93f9bad016"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v7.7.0/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9ee014c8bf434cbbcba8a0d1d0e814b5c99b60235cca39043ee3bc977dd1b744"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v7.7.0/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c248d7c4a22848b060f5136d561f9c399433f26a92d0b4f10823938b716dc47f"
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
