class Fed < Formula
  desc "Orchestrate your local dev stack from one config file"
  homepage "https://github.com/service-federation/fed"
  version "5.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v5.1.5/fed-aarch64-apple-darwin.tar.xz"
      sha256 "bfb64973952a634ce5e92fb7e01a3833a2b45ff65d588d92642beac51f928de2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v5.1.5/fed-x86_64-apple-darwin.tar.xz"
      sha256 "e868c9348fcac0503bea9895a00749a24381f865416ef552f830a1049e202f04"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v5.1.5/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ab98fd0fc470815ce88ab4565669b830f96848cfd4d28fda932e80ad1c71a8c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v5.1.5/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "66b9e268e711572913146426f0aa538861016ee2becff11d2e363512178c0f1b"
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
