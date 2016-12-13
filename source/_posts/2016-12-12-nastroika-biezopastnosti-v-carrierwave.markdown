---
layout: post
title: "Настройка безопастности в carrierwave"
date: 2016-12-12 01:27:19 +0300
comments: true
categories: Carrierwave
---
Достаточно часто возникает ситуация, при которой, загружаемые на сервер файлы не должны быть широкодоступны. Будем решать данную проблему с использованием gema carrierwave.
<!-- more -->
#Создаем модель
Собственно генерируем новый загрузчик
{% codeblock %}
rails generate uploader Picture
{% endcodeblock %}
Добавляем столбец в модель
{% codeblock %}
rails g migration add_picture_to_user picture:string
rails db:migrate
{% endcodeblock %}
Добавляем загрузчик в модель
{% codeblock question.rb %}
class User < ActiveRecord::Base
  mount_uploader :picture, PictureUploader
end
{% endcodeblock %}
#Производим настройку
Для начала нужно изменить папку, куда carriewave сохраняет файлы, по умолчанию, сохранение производится в общедоступный *public*.
{% codeblock picure_uploader.rb %}
  def store_dir
    "#{Rails.root}/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    "#{Rails.root}/uploads/tmp/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
{% endcodeblock %}
Папка в корне не является общелоступной, и припопытке скачать файл по его url мы получим ошибку. 
<br>
Дополнительно стоит ограничить загружаемые форматы и типы, например, для изображений
{% codeblock picure_uploader.rb %}
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def content_type_whitelist
    /image\//
  end

  def content_type_blacklist
    ['application/text', 'application/json']
  end
{% endcodeblock %}
#Скачивание файлов
Чтобы получить доступ к этим файлам нам необходимо внести изменения в контроллер. Мы на уровне rails приложения можем решать, позволять скачивать файл пользователю или нет. Для этого мы будем использовать функцию **send_file**, которая вместо ренедера отправляет локальный файл.
{% codeblock users_controller.rb %}  
  def download_scan
    ...
    #Проверка доступа
      send_file olimpiad.solution.file.file, :x_sendfile=>true 
    end
  end
{% endcodeblock %}
Теперь нам остатется только перенаправить запрос к данному контроллеру в роутинге.
#Предпросмотр
Не особо относящая к теме запись. При загрузке пользователем картинки, можно показать ее предпросмотр с помощью небольшого js скрипта.
{% codeblock form.html.slim %}  
= form_for current_user, :html => {:multipart => true} do |f|
  = f.file_field :picture
  .upload-preview
    img
  = f.submit("ok")

javascript:
  $(document).ready(function(){
    var preview = $(".upload-preview img");

    $("#user_picture").change(function(event){
       var input = $(event.currentTarget);
       var file = input[0].files[0];
       var reader = new FileReader();
       reader.onload = function(e){
           image_base64 = e.target.result;
           preview.attr("src", image_base64);
       };
       reader.readAsDataURL(file);
    });
  });  
{% endcodeblock %}  
#Примечание  
{% spoiler Напоминание %}
  Добавляем папку upload в .gitignore
  <br>
  Добавляем ее же в backup
  <br>
  Добавляем в shared папки в capfile
{% endspoiler %}