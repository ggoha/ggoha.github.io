---
layout: post
title: "Резервное копирование в Rails приложении"
date: 2016-12-03 19:56:14 +0300
comments: true
categories: Backup
---
Никогда не поздно начать делать бекапы, подумал я, и решил автоматизировать данный процесс в своем приложении. После похода на [The Ruby Toolbox]() я остановился на геме [backup](https://github.com/backup/backup)
<!-- more -->
##Установка
{% codeblock %}
gem install backup
{% endcodeblock %}
**Важно** не пытаться повторять мои ошибки и не ставить гем через bundler, иначе на второй запуск вы рискуете получить
NameError: uninitialized constant Module::Rails
##Настройка
Создаем модель, которая и будет осуществлять создание наших резервных копий, следующей командой
{% codeblock %}
backup generate:model  --config-file='config/backup/config.rb' --trigger my_backup \
    --databases="postgresql" --storages="dropbox" \
    --encryptor="openssl" --compressor="gzip" --notifiers="mail"
{% endcodeblock %}
Здесь мы создаем конфиг, расположенный по адресу **config/backup/config.rb** и модель к нему по адресу config/backup/models/my_backup.rb. 
Модель будет настроена для работы с PostgreSQL базой данных, сжатием, шифрованием openssl, хранением на Dropbox и уведомлением по почте.
Dropbox используется так как проект не очень большой и 2Гб Dropbox хватает с лихвой.
Сама модель очень подробно откоментирована, поэтому я остановлюсь лишь на некоторых моментах. 
Для работы с Dropbox нужно будет кроме регистрации создать еще и приложение [здесь](https://www.dropbox.com/developers/apps). В качестве разрешений достаточно работы с папкой. А при первом создании резервной копии нужно будет вручную перейти по ссылке в консоли для подтверждения прав доступа. 
Так же возножно понадобится установить дополнительные модули. Например, модуль работы с Dropbox
{% codeblock %}
backup dependencies --install dropbox-sdk
{% endcodeblock %}
Для сохранения не только базы, но и например пользовательских картинок нужно вставит
{% codeblock %}
  archive :my_archive do |archive|
    archive.add 'path/to/users/pictures'
  end
{% endcodeblock %}
Собственно запуск процесса резервного копирования 
{% codeblock %}
backup perform --trigger my_backup --config-file /config/backup/config.rb
{% endcodeblock %}
Расшифровка зашифрованного содержимого
{% codeblock %}
openssl aes-256-cbc -d -base64 -in my_backup.tar.enc  -out my_backup.tar
{% endcodeblock %}
Осталось только положить такую задачу в cron например на 2 часа ночи ежедневно
{% codeblock %}
2 2 * * * root cd /home/deploy/apps/olimpaid/shared && /home/deploy/.rbenv/shims/backup perform --trigger my_backup --config-file /home/deploy/apps/olimpaid/current/config/backup/config.rb
{% endcodeblock %}
Лучше прописывать абсолютные пути(путь до backup можно посмотреть через whereis), cd нужно для корректной работы добавления в архив папки с нашими картинками.



