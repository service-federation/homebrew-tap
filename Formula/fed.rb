class Fed < Formula
  desc "Run native apps and Docker dependencies as an isolated dev stack per Git worktree"
  homepage "https://github.com/service-federation/fed"
  version "8.3.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v8.3.3/fed-aarch64-apple-darwin.tar.xz"
      sha256 "e6f4c9c48c898e2cc1e31f41ceafed341496ba1d248da76f31a541e4e598e6af"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v8.3.3/fed-x86_64-apple-darwin.tar.xz"
      sha256 "a20760cc463a129a08b2c2a57c45a25bd7cf11e4ea2639f8cc17cdc7898e6b9c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v8.3.3/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a7b0dd615c4b914b94d8289cb117910d0f24bb6fd7aa1071a665216ada5dc347"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v8.3.3/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2464ae4fbfe972691cf04dfaa2089120cf4f2b47351ebb4d9cf867ce57ed7e4d"
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
