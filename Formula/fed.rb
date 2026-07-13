class Fed < Formula
  desc "Orchestrate your local dev stack from one config file"
  homepage "https://github.com/service-federation/fed"
  version "6.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v6.2.0/fed-aarch64-apple-darwin.tar.xz"
      sha256 "93a9e7494acc811e38af347d999c7b5ae0f905ef01e3d36bf965ddb819487910"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v6.2.0/fed-x86_64-apple-darwin.tar.xz"
      sha256 "09d4c3b80dcc2bb67c743126829b9b3a322cd1268313f261f63e882e852ee67f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/service-federation/fed/releases/download/v6.2.0/fed-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "21203d98ac31204ca7a29c60885d05ddbcbde7ea8cf522f015de4ad4a06206e2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/service-federation/fed/releases/download/v6.2.0/fed-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "83b16d6e64b3e3ed44317745613f275b17c1c0a71ebdc739f25a778a0671cb3b"
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
