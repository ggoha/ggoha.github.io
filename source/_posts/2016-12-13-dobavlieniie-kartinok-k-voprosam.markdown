---
layout: post
title: "Добавление картинок к вопросам"
date: 2016-12-13 19:30:58 +0300
comments: true
categories: Carrierwave
---
Возникла потребность, к некоторым вопросам добавлять картинки. Реализуем такую возможность, паралельно решив некоторые проблемы с CSS.
<!-- more -->
#Связь изображений с вопросами
Собственно генерируем новый загрузчик
{% codeblock %}
rails generate uploader Picture
{% endcodeblock %}
Добавляем столбец в модель
{% codeblock %}
rails g migration add_picture_to_question picture:string
rails db:migrate
{% endcodeblock %}
Добавляем загрузчик в модель
{% codeblock question.rb %}
class Question < ActiveRecord::Base
  mount_uploader :picture, PictureUploader
end
{% endcodeblock %}
В форме загрузки для поддержки множественной загрузки добавляем multipart
{% codeblock tests/edit.html.slim %}
= form_tag import_test_path, multipart: true do
  = label_tag :pictures, "Файлы с картинками"
  = file_field_tag :pictures, :multiple => true, name: "pictures[]"
  = submit_tag "Импортировать"
{% endcodeblock %}
Так как картинки загружаются отдельно от вопросов, в качестве связи между ними будет выступать название картинки, которое совпадает с номером вопроса
{% codeblock test_controller.rb %}
  def import
    @test = Test.find(params[:id])
    @test.import(params[:pictures])
    flash[:success] = "Вопросы обновлены"
    render "edit"   
  end
{% endcodeblock %}
{% codeblock test.rb %}
  if !pictures_files.blank?
    questions = self.questions.order(:id)
    pictures_files.each do |picture|
      #переводим название картинки в номер вопроса с учетом, что начинается с 0
      question_index = File.basename(picture.original_filename, ".*").to_i-1
      questions[question_index].picture = picture
      questions[question_index].save!
    end
  end
{% endcodeblock %}
Таким образом мы добавили к нашим вопросам картинки, правда без возможности их удаления.
#Показ изображения
Мы хотим получить нечто такое
{% img /images/maket2.png %}
Для этого 
{% codeblock question.html.slim %}
  .bordered
    .description
      = image_tag(@question.picture, class: "right max100percent")
      = @question.text
{% endcodeblock %}
{% codeblock style.css %}
.right{
  float: right;
}    

.bordered{
  border: 9px solid #f2f2f2;
  overflow: hidden;
}

.max100percent{
  max-width: 100%
}
{% endcodeblock %}
**float: right** нужен для обтекания картинки тестом.
**overflow: hidden** служит для правильной обработки изображения с *float* и свойства *border*
А **max-width: 100%** не позволяет даже большим изображениям занять больше размера, чем им предоставлено.
{% spoiler Другое решение %}
В случае если максимальный размер поля для изображения известен, можно производить обработку изображения при загрузке и уменьшать ее до нужного размера
  {% codeblock picture_uploader.rb %}
  class PictureUploader < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick
    ...
    process resize_to_fill: [200, 200]
  {% endcodeblock %}
{% endspoiler %}