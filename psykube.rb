require "net/http"
require "formula"

class Psykube < Formula
  LATEST_RELEASE = JSON.parse(Net::HTTP.get(URI("https://api.github.com/repos/psykube/psykube/releases/latest")))
  FALLBACK_TAG = "v1.9.3.0"
  TAG = LATEST_RELEASE["tag_name"] || FALLBACK_TAG

  version TAG.sub /^v/, ''
  homepage 'https://github.com/psykube/psykube'
  head 'https://github.com/psykube/psykube.git', branch: 'master'
  url 'https://github.com/psykube/psykube.git', using: :git, tag: TAG

  depends_on 'crystal'
  depends_on 'kubernetes-cli'

  def install
    ENV["TRAVIS_TAG"] = TAG unless build.head?
    system 'shards build --production'
    bin.install "bin/psykube"
  end
end
