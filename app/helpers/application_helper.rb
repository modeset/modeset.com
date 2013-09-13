module ApplicationHelper

  def sections
    %w(share-the-love who-we-are index how-we-work)
  end


  # Our own versions of the content and summary helpers
  def process_content_with_pipeline(post)
    HTML::Pipeline.new([
      HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::SyntaxHighlightFilter,
      HTML::Pipeline::MentionFilter
    ]).call(post.content, base_url: 'https://twitter.com/')[:output].to_s.html_safe
  end

  def post_summary(post)
    if post.summary.present?
      content_tag :p, post.summary
    else
      html = Sanitizer.new.sanitize(process_content_with_pipeline(post))
      doc = Nokogiri::HTML.fragment(html)
      para = doc.search('p').detect { |p| p.text.present? }
      para.try(:to_html).try(:html_safe)
    end
  end

end
