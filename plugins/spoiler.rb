#
# Author: ggoha
#
# Puts part of the post under spoiler
#
#   {% spoiler Please do not open %}
#   NOOO!
#   {% img NOOOO.png %} 
#   {% endspoiler %}
#   ...
#   <blockquote>
#     <p>Wheeee!</p>
#     <footer>
#     <strong>Bobby Willis</strong><cite><a href="http://google.com/search?q=pants">The Search For Bobby's Pants</a>
#   </blockquote>
#

module Jekyll
  class Spoiler < Liquid::Block
    @@sasa = 0
    def initialize(block_name, text, tokens)
      super
      @text = text.strip
    end

    def render(context)
      quote = super
      @@sasa = @@sasa + 1
      "<p><div class='octopress-spoiler-block'><input type='checkbox' id='octopress-spoiler-block-#{@@sasa}' \
      class='octopress-spoiler-block-head' checked/><label for='octopress-spoiler-block-#{@@sasa}'>#{@text} \
        </label><div class='octopress-spoiler'>"+quote+"</div></div></p>"
    end

  end
end

Liquid::Template.register_tag('spoiler', Jekyll::Spoiler)