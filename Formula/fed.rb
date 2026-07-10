class Fed < Formula
  desc "Orchestrate your local dev stack from one config file"
  homepage "https://github.com/service-federation/fed"
  version "5.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v5.1.4/fed-aarch64-apple-darwin.tar.xz"
      sha256 "9057d7341cf6372250745826fe42fad3941f3236b817405dd74246041da43adb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v5.1.4/fed-x86_64-apple-darwin.tar.xz"
      sha256 "c3d2bf40a47dd02dc6345d4d703c693d2afe21321af9ee54086b97d96ff66d01"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v5.1.4/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bd74ab182234358a29c8f7c24e75009e8e222e8f354a28c3bb9acf7f1d1ca68e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v5.1.4/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3feb080d9737fbd289081bdb3e3d2348c91d549339c79ff74b8c624fb60e996c"
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
