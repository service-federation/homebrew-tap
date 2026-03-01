class Fed < Formula
  desc "Orchestrate your local dev stack from one config file"
  homepage "https://github.com/service-federation/fed"
  version "3.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v3.2.0/fed-aarch64-apple-darwin.tar.xz"
      sha256 "17a0eb1f0ff669e2a575a3d8015af7047a74f9c8c49d2191db8ac17b3806c402"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v3.2.0/fed-x86_64-apple-darwin.tar.xz"
      sha256 "0ecb345ebbea7d794f83eea5fdcdab9f1e97a40ecb0258887f7856e1db6eff50"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v3.2.0/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e225494c8644ee32fd5369b05941d10d2272d03918e9bba7f5586f347a5a0072"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v3.2.0/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7149c817efc487237e0d3e2ad2bae06925cc1dc7512bbded9fdb941d1c4ad2b9"
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
