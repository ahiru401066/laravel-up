FROM php:latest

# 作業ディレクトリを設定
WORKDIR /var/www/

# 必要なパッケージをインストールし、ComposerとLaravelインストーラーをインストール
RUN apt update && apt install -y \
    curl \
    unzip \
    git \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer \
    && composer global require laravel/installer \
    && echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc 

# Laravel プロジェクトを作成する場合は以下のコマンドを追加 コンテナに入ってからでも良い
#RUN laravel new [app_name]

# Laravel の開発サーバを起動
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
# CMD ["bash"]
