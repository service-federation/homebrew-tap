class Fed < Formula
  desc "Orchestrate your local dev stack from one config file"
  homepage "https://github.com/service-federation/fed"
  version "3.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v3.12.0/fed-aarch64-apple-darwin.tar.xz"
      sha256 "cf3803187d618a55c13525b47a5f4cf72075ca92fae385be8af7b8dcc0b8d4cb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v3.12.0/fed-x86_64-apple-darwin.tar.xz"
      sha256 "a537e950ba9340feaf56c1aa6c5aea78ef4e98c9a201aee9b6ee63aff23370ce"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v3.12.0/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a54dcb9da08a60d8ebf337b262c2af6d541ab55324757771f5755ea7ab0ec7ca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v3.12.0/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b0e2cf6dfe3b48a0e40d5108f8ed7dfb203c02342a5c09616ff002a96591b3ef"
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
