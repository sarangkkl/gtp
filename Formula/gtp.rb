class Gtp < Formula
  desc "Manage multiple GitHub identities from the CLI"
  homepage "https://github.com/sarangkkl/gtp"
  url "https://github.com/sarangkkl/gtp/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "FILL_IN_AFTER_CREATING_RELEASE"
  license "MIT"

  def install
    bin.install "gtp"
  end

  test do
    assert_match "gtp version 1.0.0", shell_output("#{bin}/gtp version")
  end
end
