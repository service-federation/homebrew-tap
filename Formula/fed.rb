class Fed < Formula
  desc "Run native apps and Docker dependencies as an isolated dev stack per Git worktree"
  homepage "https://github.com/service-federation/fed"
  version "8.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v8.3.0/fed-aarch64-apple-darwin.tar.xz"
      sha256 "995240b2be8f67c2603e1b233c750c8433c0ce709f37af56ecd3edc5b93473d1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v8.3.0/fed-x86_64-apple-darwin.tar.xz"
      sha256 "5f08d66fd62551f71700b8cc2205b836f98174976ab40bc71632ded8339d49d0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v8.3.0/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f26c2a975cee5e94fd507ca01744f33f43bbc82c1aa87e485bc0d6bfe193980d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v8.3.0/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4375f006b0d1b525952e21538d511b649870790e7aeb412ff05166738c73ddaa"
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
