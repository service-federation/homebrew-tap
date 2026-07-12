class Fed < Formula
  desc "Orchestrate your local dev stack from one config file"
  homepage "https://github.com/service-federation/fed"
  version "5.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v5.3.0/fed-aarch64-apple-darwin.tar.xz"
      sha256 "a5ad8a908da71113abb22aef32fe7fe1e57b836d34d6a342a108b13ff22888ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v5.3.0/fed-x86_64-apple-darwin.tar.xz"
      sha256 "148b7b73510f4d1ab7cfab132d438f44d43830c46bd535205074dbf274664cc5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v5.3.0/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "43ca6c9c0584590828407d2af86540fae662507d9778d97d42ae1f5ac05b4e9a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v5.3.0/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "abbfbaced5b6be9b729a9746ef792285fbc3eafc657b6880f3610a070a19f116"
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
