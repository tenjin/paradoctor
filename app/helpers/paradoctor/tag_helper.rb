module Paradoctor
  module TagHelper
    def paradoctor_tags(referrer_content: 'origin', canonical_href: nil, replace_url: true, force: false)
      if force || request.filtered_path != request.fullpath # if filtered params exist in URL
        [
          # Try to prevent 3rd party js libs from sending Referer header
          tag('meta', name: 'referrer', content: referrer_content),

          # 3rd party js libs may use this when shipping analytics data
          tag('link', rel: 'canonical', href: canonical_href || (request.base_url + request.filtered_path)),

          # Update the user's address bar with the canonical href
          (javascript_include_tag('paradoctor') if replace_url)
        ].join("\n").html_safe
      end
    end
  end
end
