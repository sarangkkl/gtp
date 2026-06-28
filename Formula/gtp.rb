class Gtp < Formula
  desc "Manage multiple GitHub identities from the CLI"
  homepage "https://github.com/sarangkkl/gtp"
  url "https://github.com/sarangkkl/gtp/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "08546288ce536e628d7f61ba8eaeb6902e1a06a7af6e70999460cffb11151f66"
  license "MIT"

  def install
    bin.install "gtp"
  end

  test do
    assert_match "gtp version 1.0.0", shell_output("#{bin}/gtp version")
  end
end
