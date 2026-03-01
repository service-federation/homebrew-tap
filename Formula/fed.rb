class Fed < Formula
  desc "Orchestrate your local dev stack from one config file"
  homepage "https://github.com/service-federation/fed"
  version "3.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v3.2.1/fed-aarch64-apple-darwin.tar.xz"
      sha256 "6255854d2d593795f7360ae8269832ec63fc072ea5cd2c2834845d193736ef90"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v3.2.1/fed-x86_64-apple-darwin.tar.xz"
      sha256 "36c6a8714253fb1a57d82f4949b0e5797a40cb3681d9d5325ca482fe4e77c472"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v3.2.1/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a501142fb9d866c27c967e35984581420a583eb8bbd466500d725942fc362ec6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v3.2.1/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ac8afd382eaecee7d02c95a458003485b5abab4127074f5fe0542474e0635988"
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
