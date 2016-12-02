---
layout: post
title: "Удаление ошибок роутинга из rollbar"
date: 2016-12-02 15:35:35 +0300
comments: true
categories: Rollbar
---
[Rollbar](https://rollbar.com/) - замечательный инструмент для ловли ошибок на production, он избавляет от необходимости grep-ать логи и представляет сообщения об ошибках в крайне удобной форме и с массой полезной информации. К тому же он имеет бесплатное ограничение в 5000 ошибок, поэтому постараемся уменьшить количество ошибок долетающих до Rollbar 
<!-- more -->
## Rollbar
Данный пост посвящен не столь rollbar, сколько исправлению ошибок роутинга, но, возможно, я исправлю это упущение
## No route matches [GET] "/ffhnzushqco.html"
Вот такого рода запросы частенько сыплются на мой сервер. 
{% img /images/rollbar.png %}

Их цель естественно понятна, но все равно забавно наблюдать зоопарк запросов и бразузеров многие из которых упрямо стучатся на admin.php и /wordpress
Для обработки таких ошибок добавим им корректную обработку в роутинге.
В самый конец **routes.rb** добавим обработку всех остальных случаев, которые не нашли совпадения с прописанным нами роутингом.
{% codeblock routes.rb%}
match '*a', to: 'application#page_404', via: [:get, :post]
{% endcodeblock %}
Так же при желании можно ловить и delete, и put, и path.
В контролере пропишем
{% codeblock application_controller.rb %}
  def page_404
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end
{% endcodeblock %}
Мы успешно обработали все неизвестные запросы.
##Дополнительно
Совсем терять эти ошибки не хочется, кроме мусора там попадаются, например, ошибки получения картинок с нашего сайта, что необходимо исправлять. Как вариант, предлагается записывать все такие обращения просто в файл.
Для этого изменим наш контроллер
{% codeblock application_controller.rb %}
  def page_404
    File.open("#{Rails.root}/log/404.log", 'a') { |file| file.write("#{request.original_url}\n") }
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end
{% endcodeblock %}
Здесь мы открываем файл на дозапись и сохраняет адрес страницы, которую мы не можем найти. Кроме того, чтобы этот файл не перезатирался при деплое, он сохраняется в log.

Чтобы Capistrano не перезатирал папки при деплое
{% codeblock example deploy.rb %}
...
set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
...
{% endcodeblock %}

