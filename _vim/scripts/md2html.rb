#!/usr/bin/env ruby
#require 'minidown'
require 'redcarpet'

if ARGV[0] && File.exists?(file = ARGV[0])
  #puts Minidown.parse(File.read(file)).to_html
  rndr = Redcarpet::Render::HTML.new(:filter_html => true,
                                     :with_toc_data => true,
                                     :hard_wrap => true)
  markdown = Redcarpet::Markdown.new(rndr,
                                     :fenced_code_blocks => true,
                                     :autolink => true,
                                     :strikethrough => true,
                                     :no_intra_emphasis => true,
                                     :table => true,
                                     :strikethrough => true,
                                     :space_after_headers => true)
  puts markdown.render(File.read(file))
else
  puts "usage: #$0 FILE"
end
