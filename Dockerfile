FROM rstudio/r-base:3.5-bionic

# Never prompt the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

ENV R_BASE_VERSION 3.5.3

# Never prompt the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Airflow
ARG AIRFLOW_VERSION=1.10.7
ARG AIRFLOW_USER_HOME=/usr/local/airflow
ARG AIRFLOW_DEPS=""
ARG PYTHON_DEPS=""
ENV AIRFLOW_HOME=${AIRFLOW_USER_HOME}

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8

# Disable noisy "Handling signal" log messages:
# ENV GUNICORN_CMD_ARGS --log-level WARNING

################# MY STUFF

# Install Python
RUN apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip

# Python libraries
COPY requirements.txt ./

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

################# END MY STUFF



RUN set -ex \
    && buildDeps=' \
        freetds-dev \
        libkrb5-dev \
        libsasl2-dev \
        libssl-dev \
        libffi-dev \
        libpq-dev \
        git \
    ' \
    && apt-get update -yqq \
    && apt-get upgrade -yqq \
    && apt-get install -yqq --no-install-recommends \
        $buildDeps \
        freetds-bin \
        build-essential \
        default-libmysqlclient-dev \
        apt-utils \
        curl \
        rsync \
        netcat \
        locales \
        openssl \
        curl \
        vim \
        gnupg2 \
        git \
        wget \
        dirmngr --install-recommends \
        apt-transport-https \
        ca-certificates \
        software-properties-common \
        libxml2-dev \
        libssl-dev \
        libcurl4-openssl-dev \
    && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && useradd -ms /bin/bash -d ${AIRFLOW_USER_HOME} airflow \
    && pip install -U pip setuptools wheel \
    && pip install pytz \
    && pip install pyOpenSSL \
    && pip install ndg-httpsclient \
    && pip install pyasn1 \
    && pip install apache-airflow[crypto,celery,postgres,hive,jdbc,mysql,ssh${AIRFLOW_DEPS:+,}${AIRFLOW_DEPS}]==${AIRFLOW_VERSION} \
    && pip install 'redis==3.2' \
    && if [ -n "${PYTHON_DEPS}" ]; then pip install ${PYTHON_DEPS}; fi \
    && apt-get purge --auto-remove -yqq $buildDeps \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

######## BEGINNING OF MY SHIT

# install RVM, Ruby
RUN gpg2 --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s
RUN bash -l -c ". /etc/profile.d/rvm.sh && rvm install 2.3.7"
COPY . /app

# Ruby gems
RUN bash -l -c "gem install chromedriver-helper -v '1.2.0'"
RUN bash -l -c "gem install capybara -v '2.13.0'"
RUN bash -l -c "gem install selenium-webdriver -v '3.11.0'"

# install chromedriver
RUN apt-get install -yqq unzip
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/


# R Things
RUN apt-get update && \
  apt-get install -y libcurl4-openssl-dev libssl-dev libssh2-1-dev libxml2-dev && \
  R -e "install.packages(c('devtools', 'testthat', 'roxygen2'), repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('dplyr',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('tidyr',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('ggplot2',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('readxl',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('XML',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('lubridate',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('doParallel',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('profvis',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('readr',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('knitr',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('R.utils',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('stringr',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('mgcv',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('parallel',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('RSQLite',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('tidyverse',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('ggrepel',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('lme4',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('broom',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('RSQLite',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('etl',dependencies=TRUE, repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('zoo',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('vroom',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/latticeExtra/latticeExtra_0.6-28.tar.gz', repos=NULL, type='source')"
RUN R -e "devtools::install_github('BillPetti/baseballr')"

######### END OF MY SHIT

COPY script/entrypoint.sh /entrypoint.sh
COPY config/airflow.cfg ${AIRFLOW_USER_HOME}/airflow.cfg
COPY dags/* ${AIRFLOW_USER_HOME}/dags/

RUN chown -R airflow: ${AIRFLOW_USER_HOME}

EXPOSE 8080 5555 8793

USER airflow
WORKDIR ${AIRFLOW_USER_HOME}
RUN bash -l -c "echo 'source /usr/local/rvm/scripts/rvm' >> ~/.bashrc"
ENTRYPOINT ["/entrypoint.sh"]
CMD ["webserver"]
