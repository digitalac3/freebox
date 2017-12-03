#!/bin/bash

# /*=======================================
# = CORE CONFIGURATIONS                   =
# ========================================*/
echo "==== Core configurations ===="
  sudo cp /vagrant/provision/configs/banner.txt /etc/update-motd.d/00-header

echo "Adding necessary additional repositories..."
  # PHP 7 
  sudo add-apt-repository ppa:ondrej/php

  # MariaDB
  sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
  sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://sgp1.mirrors.digitalocean.com/mariadb/repo/10.2/ubuntu trusty main'

  # Yarn
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

  # PostgreSQL
  sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
  wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -

echo "Checking for updates..."
  sudo apt-get update > /dev/null

echo "Installing essential build tools..."
  sudo apt-get install -y zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev software-properties-common > /dev/null

echo "Installing Git..."
  sudo apt-get install git -y > /dev/null

echo "Installing debconf-utils..."
  sudo apt-get install -y debconf-utils > /dev/null

echo "Installing vim..."
  sudo apt-get install -y vim > /dev/null

# /*=======================================
# = INSTALL LAMP STACK                    =
# ========================================*/
echo "Installing Apache2..."
  sudo apt-get install -y apache2 > /dev/null

echo "Installing MariaDB..."
  DATABASE_ROOT_PASS="root"
  sudo debconf-set-selections <<< "mariadb-server-10.0 mysql-server/root_password password $DATABASE_ROOT_PASS"
  sudo debconf-set-selections <<< "mariadb-server-10.0 mysql-server/root_password_again password $DATABASE_ROOT_PASS"
  sudo apt install mariadb-server -y > /dev/null

echo "Running mysql_secure_installation..."
  mysql -u root -p"$DATABASE_ROOT_PASS" -e "UPDATE mysql.user SET Password=PASSWORD('$DATABASE_ROOT_PASS') WHERE User='root'"
  mysql -u root -p"$DATABASE_ROOT_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
  mysql -u root -p"$DATABASE_ROOT_PASS" -e "DELETE FROM mysql.user WHERE User=''"
  mysql -u root -p"$DATABASE_ROOT_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
  mysql -u root -p"$DATABASE_ROOT_PASS" -e "FLUSH PRIVILEGES"

echo "Installing PHP7..."
  sudo apt-get install -y php7.0 libapache2-mod-php7.0 php7.0-cli php7.0-common php7.0-mbstring php7.0-gd php7.0-intl php7.0-xml php7.0-mysql php7.0-mcrypt php7.0-zip > /dev/null

# /*=======================================
# = INSTALL NODEJS                        =
# ========================================*/
echo "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash
  # Source nvm
  . ~/.nvm/nvm.sh

echo "Installing NodeJS latest LTS..."
  nvm install --lts > /dev/null
  nvm use --lts
  node -v

# /*=======================================
# = INSTALL RUBY WITH ROR                 =
# ========================================*/
echo "Installing rbenv..."
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
  . ~/.bashrc

  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
  

echo "Installing Ruby 2.4.2..."
  sudo -H -u vagrant bash -i -c 'rbenv install 2.4.2' > /dev/null
  sudo -H -u vagrant bash -i -c 'rbenv global 2.4.2' > /dev/null
  sudo -H -u vagrant bash -i -c 'ruby -v'

echo "Installing bundler..."
  # sudo -H -u vagrant bash -i -c 'gem install bundler' > /dev/null
  # sudo -H -u vagrant bash -i -c 'rbenv rehash' > /dev/null

echo "Installing Rails 5.1.4..."
  # sudo -H -u vagrant bash -i -c 'gem install rails -v 5.1.4' > /dev/null
  # sudo -H -u vagrant bash -i -c 'rbenv rehash' > /dev/null
  # rails -v

echo "Installing PostgreSQL 9.5..."
  # sudo apt-get install -y postgresql-common postgresql-9.5 libpq-dev > /dev/null

# /*=======================================
# = CLEAN UP                              =
# ========================================*/
echo "Cleaning up the box..."
  sudo apt-get clean
  # sudo dd if=/dev/zero of=/EMPTY bs=1M
  sudo rm -f /EMPTY
  cat /dev/null > ~/.bash_history && history -c && exit