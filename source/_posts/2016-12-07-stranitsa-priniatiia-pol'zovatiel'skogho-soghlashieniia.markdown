---
layout: post
title: "Страница принятия пользовательского соглашения"
date: 2016-12-07 20:51:16 +0300
comments: true
categories: 
---
Схематично страница с принятием пользовательского соглашения выглядит так
{% img /images/maket1.png %}
Нечто такое и мы будем реализовывать
<!-- more -->
## Текст договора
Вручную оформлять этот многостраничный договор с пунктами и подпунктами в html на странице долго и некрасиво. Будем выгружать его из файла.
{% codeblock slim %}
 = File.read "DOGOVOR.txt"
{% endcodeblock %}
Списки и подсписки перенеслись нормально, а вот с переносы строк html не воспринимает. Это сожно исправить с помощью хелпера simple format, он переводит **\n** в **<br\>**. Кроме того нужно показать, что этот текст уже содержит html-теги с помощью html_safe.
{% codeblock slim %}
 = simple_format(File.read "DOGOVOR.txt").html_safe
{% endcodeblock %}
## Согласие с договором 
Мы хотим чтобы без нажатого принятия договора не происходил переход к следующей странице. С появлением html5 это стало сделать гораздо легче. Для этого нам понадобится атрибут required примененный к checkbox.
{% codeblock slim %}
= form_tag() do
  input id="field_terms" type="checkbox" required=true
  = submit_tag("Заплатить")
{% endcodeblock %}
Для русификации ошибки
{% codeblock javascript %}
  document.getElementById("field_terms").setCustomValidity("Для продолжения оплаты, Вы должны принять правила пользования");
{% endcodeblock %}
Что бы использовать вместо стандартного checkbox свою картинку, придется скрыть defoult, а изображение показывать вместо связанного labela. Связь по id checkbox позволяет изменять значение при клике на соответствующий label.
{% codeblock form.html.slim %}
      input  id="field_terms" type="checkbox" required=true
      label for="field_terms"
      label for="field_terms" С правилами пользования сервисом согласен
{% endcodeblock %}

{% codeblock css style.scss %}
  #field_terms {
    //скрываем defoult
    position: absolute;
    opacity: 0;
    //передвигаем окошко ошибки
    top: 40px;
    left: 15px;
  }

  #field_terms + label {
    //показываем новый checkbox
    background: image_url('acceptoff.png') no-repeat;
    height: 50px;
    width: 50px;
    display:inline-block;
    padding: 0 0 0 0px;
  }

  #field_terms:checked + label {
    //показываем новый нажатый checkbox
    background: image_url('accepton.png') no-repeat;
  }

  #field_terms + label, #field_terms + label + label {
    cursor: pointer;
  }
{% endcodeblock %}
## Многострочная строчка с разными стилями строк
На самом деле никакая это не кнопка. Это будет стилизованная под кнопку ссылка с div внутри. 
{% codeblock html.slim %}
  .inline-block
    / Видимая ссылка маскирующаяся под кнопку, при нажатии на которую вызывается нажатие на настоящую
    .button
      a href="javascript:;" onclick="document.getElementById('submit').click();" class="text"
        . Заплатить<br>много денег
    / Невидимая настоящая
    = submit_tag("Заплатить много денег", id: "submit", hidden: true)
{% endcodeblock %}

{% codeblock style.scss %}
  .text div {
    font-size:16px;
    color: black;
  }

  .text div:first-line {
    //отдельный стиль для первой строки
    font-size:20px;
    font-weight:bold;
  }
{% endcodeblock %}