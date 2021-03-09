require "net/http"
require "formula"

class Psykube < Formula
  TAG = JSON.parse(Net::HTTP.get(URI("https://api.github.com/repos/psykube/psykube/tags?per_page=1"))).first["name"]

  version TAG&.sub /^v/, ''
  homepage 'https://github.com/psykube/psykube'
  head 'https://github.com/psykube/psykube.git', branch: 'master'
  url 'https://github.com/psykube/psykube.git', using: :git, tag: TAG

  depends_on 'crystal'
  depends_on 'kubernetes-cli'

  def install
    ENV["TRAVIS_TAG"] = TAG unless build.head?
    system 'shards build --production --release --no-debug --progress'
    bin.install "bin/psykube"
  end
end
