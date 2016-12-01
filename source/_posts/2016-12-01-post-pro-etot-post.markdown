---
layout: post
title: "Пост про этот пост"
date: 2016-12-01 15:29:26 +0300
comments: true
categories: 
---
## Введение
В какой-то момент я решил все-таки перенести свою маленькую записную книжку по тем приемам, которые я использовал во время создания различных сайтов, из отдельного списка в Trello в нечто более осязаемое, например, блог. Ну и еще немного практики никому не мешало.
<!-- more -->
## Выбор
Писать свой собственный движок для блога я не стал, возможно в качестве первого(ну или почти первого) знакомства с rails это хорошая идея([1][1]), но для меня это все-таки больше записная книжка. Выбор осуществлялся достаточно просто, путем захода на [The Ruby Toolbox](https://www.ruby-toolbox.com/categories/Blog_Engines) и беглым знакомством с уже существующими решениями. Так мой выбор пал на [Octopress](http://octopress.org)
## Установка
Будем считать что у нас уже есть установленный rvm(или rbenv) а так же ruby.
{% codeblock bash %}
git clone git://github.com/imathis/octopress.git octopress
cd octopress
bundle install
{% endcodeblock %}
Устанавливаем для начала дефолтную тему
{% codeblock %}
rake install['THEME_NAME']
rake generate
{% endcodeblock %}
Конфигурационный файл можно пока не трогать
Посмотреть, что получается из коробки можно следующим образом
{% codeblock %}
rake generate
rake preview
{% endcodeblock %}
Данные команды перегенируют статические страницы и выводят результат по-умолчанию на [localhost:4000](localhost:4000) 
### Настройка

### Хостинг
Так как в результате работы получаются статические страницы, то вполне резонно использовать не полноценный сервер, а просто хостера статических сайтов, благо Octopress предлагает [3 варианта](http://octopress.org/docs/deploying/). Я остановился на GitHub Pages.  
[После создания соответствующего репозитория](http://isizov.ru/github-kak-hosting-dlya-sajtov/)
Необходимо выполнить
{% codeblock %}
rake setup_github_pages
{% endcodeblock %}
и указать SSH или HTTPS URL до вашего репозитория.
Затем надо выполнить
{% codeblock %}
rake generate
rake deploy
{% endcodeblock %}
или одной командой
{% codeblock %}
rake gen_deploy
{% endcodeblock %}
Затем надо выполнить
{% codeblock %}
git add .
git commit -m 'your message'
git push origin source
{% endcodeblock %}
## Создание поста
Теперь мы получили пустой блог. Займемся его наполнением. 
Для добавления нового поста, например, этого, введем 
{% codeblock %}
rake new_post["Пост про этот пост"]
{% endcodeblock %}
После этого название транслитерируется и становится доступным по адресу, структура которого указана в **_config.yml**
Сам файл будет почти пустым
{% codeblock %}
---
layout: post
title: "Пост про данный пост"
date: 2016-12-01 11:12:15 +0300
comments: true
categories: 
---
{% endcodeblock %}
Здесь можно добавить категории и дополнительно указать автора.
Далее идет пространство для непостредственно написания текста поста. Для этого используется язык разметки Markdown. [Синтаксис](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) очень простой, практически ничего не отвлекает от непосредственно написания текста.   
### Добавление картинок

### Оформление кода
В моем случае, я часто использовал вставки кода, поэтому важно чтобы они были красиво оформленны. В Markdown есть выделение и подсветка синтакиса, но специальный плагин [Codeblock](https://github.com/octopress/codeblock) делает это гораздо красивее. В частности все вставки кода в этой статье были выполнены именно с его использованием.
Дополнительнительную информацию вы всегда можете получить [здесь](https://github.com/octopress/codeblock)


[1]: https://www.railstutorial.org/ 'Ruby on Rails Tutorial (Rails 5)'
[2]: http://ajaxblog.ru/octopress/octopress-blogging-for-geeks/ "Octopress - блоггинг для гиков"
[3]: http://asakasinsky.ru/2012/06/03/opisaniie-octopress/ "Описание Octopress"
