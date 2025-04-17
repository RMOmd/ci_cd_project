# Используем базовый образ Python
FROM python:3.12.0a4-alpine3.17

# Обновляем репозитории Alpine
RUN echo "https://dl-4.alpinelinux.org/alpine/v3.10/main" >> /etc/apk/repositories && \
    echo "https://dl-4.alpinelinux.org/alpine/v3.10/community" >> /etc/apk/repositories

# Устанавливаем chromedriver и другие зависимости
RUN apk update && \
    apk add --no-cache chromium chromium-chromedriver tzdata

# Устанавливаем glibc
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-bin-2.30-r0.apk && \
    apk add glibc-2.30-r0.apk glibc-bin-2.30-r0.apk && \
    rm glibc-2.30-r0.apk glibc-bin-2.30-r0.apk

# Устанавливаем Java и Allure
RUN apk update && \
    apk add openjdk11-jre curl tar && \
    curl -o allure-2.13.8.tgz -Ls https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.13.8/allure-commandline-2.13.8.tgz && \
    tar -zxvf allure-2.13.8.tgz -C /opt/ && \
    ln -s /opt/allure-2.13.8/bin/allure /usr/bin/allure && \
    rm allure-2.13.8.tgz

# Устанавливаем рабочую директорию
WORKDIR /usr/workspace

# Копируем requirements.txt в контейнер
COPY ./requirements.txt /usr/workspace/requirements.txt

# Устанавливаем Python-зависимости
RUN pip3 install --no-cache-dir -r /usr/workspace/requirements.txt

# Копируем остальные файлы проекта в контейнер
COPY . /usr/workspace

# Команда для запуска тестов
CMD ["pytest"]
