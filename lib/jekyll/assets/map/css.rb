# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "sprockets"

module Jekyll
  module Assets
    module Map
      class CSS < Sprockets::SassCompressor
        def call(input)
          out = super(input)
          env = input[:environment].uncached
          asset = env.find_source!(env.strip_paths(input[:filename]))
          path = asset.filename.sub(env.jekyll.in_source_dir + "/", "")
          url = Map.map_path(asset: asset, env: env)
          url = env.prefix_url(url)

          out.update({
            data: <<~CSS
              #{out[:data].strip}
              /*# sourceMappingURL=#{url} */
              /*# sourceURL=#{path} */
            CSS
          })
        end
      end

      content_type = "text/css"
      Sprockets.register_compressor content_type, \
        :source_map, CSS
    end
  end
end
