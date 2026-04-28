class Fed < Formula
  desc "Orchestrate your local dev stack from one config file"
  homepage "https://github.com/service-federation/fed"
  version "3.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v3.7.0/fed-aarch64-apple-darwin.tar.xz"
      sha256 "20b2561c4258315d3c36600b7d2a15737def73daafa5b64ce60b9ee1f65de177"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v3.7.0/fed-x86_64-apple-darwin.tar.xz"
      sha256 "d1cf8697beae418842998afaed1fc1e9e61e936727605b61397fa9a95e8e7160"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v3.7.0/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d6b57ece7fd8d430700439899b8406748376747c966ac558bda901b43e7abe99"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v3.7.0/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7d4b9da36949a3538eb6b1bef378bbd728bdc47061cde2124c2aa9d9b3b2d29e"
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
