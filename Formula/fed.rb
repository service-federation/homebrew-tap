class Fed < Formula
  desc "Orchestrate your local dev stack from one config file"
  homepage "https://github.com/service-federation/fed"
  version "3.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v3.11.0/fed-aarch64-apple-darwin.tar.xz"
      sha256 "e00b0a49612399edc2a5fdfca5d560a9ebffccdbfae39756a7a7e555a44dc754"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v3.11.0/fed-x86_64-apple-darwin.tar.xz"
      sha256 "4a8bc19303fcfebe76297e86dad665d6cee0b749a245942142668c252b43c86e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v3.11.0/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fb651322484d7b2a2c2cf7c2de60652e19d9f1112609e95d0ec28ac1fcce786d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v3.11.0/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5c5aafc4d352ae1d60c6c059db7ffe0ebdfaa9014c304ebc6878a51486b41731"
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
