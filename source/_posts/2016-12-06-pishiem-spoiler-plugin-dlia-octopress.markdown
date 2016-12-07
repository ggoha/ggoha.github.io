---
layout: post
title: "Пишем spoiler-plugin для octopress"
date: 2016-12-06 18:08:30 +0300
comments: true
categories: Octopress
---
Мне изначально хотелось скрывать некоторые части постов под спойлер, например вот так
{% img /images/spoiler.png %}

Я смог найти только вот [это](https://github.com/seanhagen/octopress-spoiler-tag/blob/master/spoiler.rb)
Но меня это не устраивало, так как это был однострочный спойлер, например, для "спойлеров" в фильме. Я же хотел скрывать некоторую часть текста, например, описание исправлений ошибок, которые в большинстве случаев не имеет смысла показывать.
Поэтому я решил написать его сам. Кроме того, я решил не использовать js, а обойтись только HTML/CSS.
<!-- more -->
<script async src="//jsfiddle.net/hephunLe/16/embed/"></script>
## CSS3
Основная идея следующая
Переключатель представляет собой checkbox, для нажатого check с помощью селектора + (выбирающего следующие элементы) мы устанавливаем display:none для спойлерных объектов. 
{% spoiler Пояснение#1 %}
  {% codeblock %}
    .octopress-spoiler-block + label {
      cursor: pointer;
    }
  {% endcodeblock %}
  Позволяет изменять значение checkbox-a при нажатии на связанную с ним по id надпись. 
{% endspoiler %}

{% spoiler Пояснение#2 %}
  {% codeblock %}
    .octopress-spoiler-block:not(checked) {
      position: absolute;
      opacity: 0;
    }
  {% endcodeblock %}
  Убирает с глаз долой дефолтный checkbox.
{% endspoiler %}
## Ruby
Основную структуру плагина я подсматривал у [blockquote](https://github.com/imathis/octopress/blob/master/plugins/blockquote.rb).
{% codeblock spoiler.rb %}
module Jekyll
  class Spoiler < Liquid::Block 
  #Зависит от того блок (многострочный как blockquote) это или тег (однострочный как image)
    def initialize(block_name, text, tokens)
    #собственно инициализация
      #здесь нам делать особо нечего
      #но возможно есть что инициализировать классу, что выше в цепочке наследования
      super
      @text=text
    end

    def render(context)
    #и вывод html
      #получаем результат render-a предка
      quote = super 
      #оборачиваем в div, добавлем checkbox и label
      "<div id='octopress-spoiler-block'><input type='checkbox' id='octopress-spoiler-block' \
      class='octopress-spoiler-block-head' checked/><label for='octopress-spoiler-block'> \ 
      #{@text} </label><div id='octopress-spoiler'>"+quote+"</div></div>"
    end

  end
end
Liquid::Template.register_tag('spoiler', Jekyll::Spoiler)
{% endcodeblock %}
{% spoiler Для поддержки нескольких спойлеров %}
  Нам необходимо понимать к какому checkbox относится label, это можно сделать с использованием id. Для этого нужно каждому спойлеру присвоить свой уникальный номер. В этом нам помогут переменные класса.
  {% codeblock spoiler.rb %}
    class Spoiler < Liquid::Block
      @@sasa = 0
    ...
      def render(context)
        quote = super
        @@sasa = @@sasa + 1
        "<p><div class='octopress-spoiler-block'><input type='checkbox' \
        id='octopress-spoiler-block-#{@@sasa}' class='octopress-spoiler-block-head' \
        checked/><label for='octopress-spoiler-block-#{@@sasa}'>#{@text} \
        </label><div class='octopress-spoiler'>"+quote+"</div></div></p>"
      end
    }
  {% endcodeblock %}
  При каждом новом рендере, номер в id будет увеличиваться, что нам и необходимо.
{% endspoiler %}

К сожалению, сразу формить все это в виде гема не удалось, возможно это материал для одной из следующих заметок

##Литература
При подготовке я много интересного для себя подчерпнул из [1](http://everstudent.ru/blog/htmlcss/30-css-seletors-to-memorize/)
и [2](http://everstudent.ru/blog/htmlcss/30-css-seletors-to-memorize/)