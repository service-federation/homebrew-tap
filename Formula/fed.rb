class Fed < Formula
  desc "Orchestrate your local dev stack from one config file"
  homepage "https://github.com/service-federation/fed"
  version "6.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v6.4.0/fed-aarch64-apple-darwin.tar.xz"
      sha256 "82127fa7828066d0aa200cc78c5c3320c71c6710bf5c61db97f19df41c7f95d8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v6.4.0/fed-x86_64-apple-darwin.tar.xz"
      sha256 "316b3e71324f16bcdd7f87ea8d8e6b0dcaad49fc170e290e5cbfc922e81ebe45"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v6.4.0/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0a05332bd6bb49cf823d608143820641f839a50ebce77a636c0635fcc14e877e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v6.4.0/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7898544dba260db572bc449b35653b2a1f801dd1b4428205447e4a333e2a773c"
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
