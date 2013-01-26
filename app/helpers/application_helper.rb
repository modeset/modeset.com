module ApplicationHelper
  def sections
    %w(share-the-love who-we-are index how-we-work)
  end

  def process_content_with_pipeline(post)
    HTML::Pipeline.new([
      HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::SyntaxHighlightFilter
    ]).call(post.content)[:output].to_s.html_safe
  end
end
