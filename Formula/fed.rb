class Fed < Formula
  desc "Run native apps and Docker dependencies as an isolated dev stack per Git worktree"
  homepage "https://github.com/service-federation/fed"
  version "8.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v8.1.0/fed-aarch64-apple-darwin.tar.xz"
      sha256 "ecddd293944c7f9278fe44d287abb7486b844d1d20980ab7676c1c11c5bface6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v8.1.0/fed-x86_64-apple-darwin.tar.xz"
      sha256 "1fa661947efbe7b30eabb3547128036140784ebf68bb13117a4c66527c0d7ca4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v8.1.0/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "330f0fa757806530a375d7cf6436c4e913708ef5fc5fb02459d3abd1b9263174"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v8.1.0/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ac86204ca9ddb714e3d9de5f873163c7b64394ab978e1c1ffe2342843ab3f8c3"
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
