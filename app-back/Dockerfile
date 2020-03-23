
# Base Stage
FROM debian:buster AS base

## LOCAL TIMEZONE
ENV TZ ":America/Bogota"

# Installing python
## CONFIGURE LOCALES
## CONFIGURE LOCALES
RUN apt-get update && apt-get install -y locales                      && \
  sed -i 's%^# en_US.UTF-8 UTF-8$%en_US.UTF-8 UTF-8%' /etc/locale.gen && \
  locale-gen

ENV LANG en_US.UTF-8

ENV APP_PATH "/app/"


RUN apt-get install -y python-setuptools gcc

## UPDATE REPOSITORIES, INSTALL PIP AND BUILD DEPENDENCIES
RUN apt-get update && \
  apt-get install -y  \
    python3.7     \
    zlib1g-dev    \
    python3.7-dev \
    libldap2-dev  \
    libsasl2-dev  \
    libpq-dev     \
    libpcre3      \
    libpcre3-dev  \
    libpython3.7  \
    pandoc        \
    git           \
    wget          \
    python3-gdal  \
    unzip         \
    curl          \
    libjpeg62-turbo-dev  \
    python3-setuptools


## USE Python3.5 AND PIP3 BY DEFAULT
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1

## NEED TO INSTALL A MODERN VERSION OF PIP DUE TO PROXY PROBLEMS (and its dep setuptools)
RUN curl -L --retry 5 https://files.pythonhosted.org/packages/c2/f7/c7b501b783e5a74cf1768bc174ee4fb0a8a6ee5af6afa92274ff964703e0/setuptools-40.8.0.zip \
  > /tmp/setuptools-40.8.0.zip                       && \
  cd /tmp/ && unzip setuptools-40.8.0.zip            && \
  cd setuptools-40.8.0 && python setup.py install    && \
  cd .. && rm -rf setuptools-40.8.0 setuptools-40.8.0.zip

RUN curl -L --retry 5 https://files.pythonhosted.org/packages/36/fa/51ca4d57392e2f69397cd6e5af23da2a8d37884a605f9e3f2d3bfdc48397/pip-19.0.3.tar.gz \
  > /tmp/pip-19.0.3.tar.gz                       && \
  cd /tmp/      && tar xvzf pip-19.0.3.tar.gz    && \
  cd pip-19.0.3 && python setup.py install       && \
  cd .. && rm -rf pip-19.0.3.tar.gz pip-19.0.3

## VALUE BE devel OR master AS DEFINED IN THE COMPOSE FILE
ARG branch
ARG repository
ARG folder

## GET KEYS TO GITHUB
ADD .ssh/* /root/.ssh/

    ## AVOID BUG W/  DOCKER+PYTHON3.5 AND SEEKI
RUN chmod 777 /dev/stdout /dev/stderr && \
    cd /tmp/ && chmod 0600 /root/.ssh/id_rsa && \
    eval "$(ssh-agent)" && \
    ssh-add /root/.ssh/id_rsa && \
    ssh-keyscan github.com > /root/.ssh/known_hosts && \
    ssh-add -l && git clone ${repository} --branch ${branch} ${folder} && \
    rm -r /root/.ssh && \
    ## GET requirements.txt FROM GITHUB
    pip install -r /tmp/${folder}/requirements.txt && \
    mkdir /app && \
    mv ${folder} /app/ && \
    ## DO NOT RUN CELERY / GUNICORN AS ROOT
    groupadd -g 1000 -r django && useradd -r -u 1000 -g django django

## COPY ENTRYPOINT SCRIPT
COPY django-entrypoint.sh /docker-entrypoint.sh

## CREATE A SPACE TO MOUNT DATA AND MOVE TO IT
WORKDIR /app

USER django

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8000

##########################################################################

# Base Stage
FROM debian:buster AS development

## LOCAL TIMEZONE
ENV TZ ":America/Bogota"

# Installing python
## CONFIGURE LOCALES
## CONFIGURE LOCALES
RUN apt-get update && apt-get install -y locales                      && \
  sed -i 's%^# en_US.UTF-8 UTF-8$%en_US.UTF-8 UTF-8%' /etc/locale.gen && \
  locale-gen

ENV LANG en_US.UTF-8

ENV APP_PATH "/app/"


RUN apt-get install -y python-setuptools gcc

## UPDATE REPOSITORIES, INSTALL PIP AND BUILD DEPENDENCIES
RUN apt-get update && \
  apt-get install -y  \
    python3.7     \
    zlib1g-dev    \
    python3.7-dev \
    libldap2-dev  \
    libsasl2-dev  \
    libpq-dev     \
    libpcre3      \
    libpcre3-dev  \
    libpython3.7  \
    pandoc        \
    git           \
    wget          \
    python3-gdal  \
    unzip         \
    curl          \
    libjpeg62-turbo-dev  \
    python3-setuptools


## USE Python3.5 AND PIP3 BY DEFAULT
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1

## NEED TO INSTALL A MODERN VERSION OF PIP DUE TO PROXY PROBLEMS (and its dep setuptools)
RUN curl -L --retry 5 https://files.pythonhosted.org/packages/c2/f7/c7b501b783e5a74cf1768bc174ee4fb0a8a6ee5af6afa92274ff964703e0/setuptools-40.8.0.zip \
  > /tmp/setuptools-40.8.0.zip                       && \
  cd /tmp/ && unzip setuptools-40.8.0.zip            && \
  cd setuptools-40.8.0 && python setup.py install    && \
  cd .. && rm -rf setuptools-40.8.0 setuptools-40.8.0.zip

RUN curl -L --retry 5 https://files.pythonhosted.org/packages/36/fa/51ca4d57392e2f69397cd6e5af23da2a8d37884a605f9e3f2d3bfdc48397/pip-19.0.3.tar.gz \
  > /tmp/pip-19.0.3.tar.gz                       && \
  cd /tmp/      && tar xvzf pip-19.0.3.tar.gz    && \
  cd pip-19.0.3 && python setup.py install       && \
  cd .. && rm -rf pip-19.0.3.tar.gz pip-19.0.3

## VALUE BE devel OR master AS DEFINED IN THE COMPOSE FILE
ARG branch
ARG repository
ARG folder

## GET KEYS TO GITHUB
ADD .ssh/* /root/.ssh/

    ## AVOID BUG W/  DOCKER+PYTHON3.5 AND SEEKI
RUN chmod 777 /dev/stdout /dev/stderr && \
    cd /tmp/ && chmod 0600 /root/.ssh/id_rsa && \
    eval "$(ssh-agent)" && \
    ssh-add /root/.ssh/id_rsa && \
    ssh-keyscan github.com > /root/.ssh/known_hosts && \
    ssh-add -l && git clone ${repository} --branch ${branch} ${folder} && \
    rm -r /root/.ssh && \
    ## GET requirements.txt FROM GITHUB
    cd ${folder} && \
    pip install -r requirements.txt && \
    mkdir /app && \
    mv ${folder} /app/ && \
    ## DO NOT RUN CELERY / GUNICORN AS ROOT
    groupadd -g 1000 -r django && useradd -r -u 1000 -g django django

## COPY ENTRYPOINT SCRIPT
COPY django-entrypoint.sh /docker-entrypoint.sh

## CREATE A SPACE TO MOUNT DATA AND MOVE TO IT
WORKDIR /app

USER django

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8000
