class Fed < Formula
  desc "Orchestrate your local dev stack from one config file"
  homepage "https://github.com/service-federation/fed"
  version "4.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v4.0.0/fed-aarch64-apple-darwin.tar.xz"
      sha256 "8d1cf61a0082acf538d5b907f70b2e63c6033b975c271e3dbd55e8ebcbe6b688"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v4.0.0/fed-x86_64-apple-darwin.tar.xz"
      sha256 "617215742ede65876b4b8207795438a99a9d9116a2e1316738bb1a5717d85014"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v4.0.0/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9ec1b91398afcdd226d6bcc10a2bb5ba579212565ef97335c1767f06beaea88a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v4.0.0/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3b87886a2649f4dec8a2f1a29b0836d9c752a1885ae47c304ff528730db2193c"
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
