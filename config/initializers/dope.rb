require "persey"

Persey.init Rails.env do
  env :production do
    posts do
      similarity_threshold 0.7
      recency_window 1.hour
      prefix_length 300
      title_max_length 200
    end

    url do
      port 80
      host "dopo-nemytchenko.replit.app"
    end
  end

  env :development, parent: :production do
    url do
      port 3333
      host "dope.local"
    end
  end

  env :test, parent: :production do
    url do
      port 80
      host "dope.local"
    end
  end
end

module Dope
  def self.config
    Persey.config
  end

  def self.markdown
    @markdown ||= Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      autolink: true,
      tables: true,
      fenced_code_blocks: true,
      strikethrough: true
    )
  end
end
