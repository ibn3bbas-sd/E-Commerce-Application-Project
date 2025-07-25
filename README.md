# 🛒 E-Commerce Application Setup (LAMP Stack on CentOS)

This guide provides step-by-step instructions to set up a PHP-based e-commerce application using **CentOS**, **Apache**, **MariaDB**, and **PHP** (LAMP stack) 

**The LAMP stack** is a popular open-source software stack used for web development. It consists of four key components:

- 🐧 Linux: The operating system that serves as the foundation.
- 🌐 Apache: A widely used web server that handles HTTP requests.
- 🐬 MySQL: A relational database management system for storing and managing data.
- 🐘 PHP, Perl, or Python: The programming language used for dynamic content and backend logic.

Together, these components create a powerful environment for hosting and developing web applications, especially dynamic websites and content management systems like WordPress

---

## 📦 Tech Stack

- **OS**: CentOS
- **Web Server**: Apache (httpd)
- **Database**: MariaDB
- **Server-Side Language**: PHP

---

## ⚙️ Deploy Pre-Requisites

1. Install FirewallD

```
sudo yum install -y firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo systemctl status firewalld
```

## 🛠️ Deploy and Configure Database

1. Install MariaDB

```
sudo yum install -y mariadb-server
sudo vi /etc/my.cnf
sudo systemctl start mariadb
sudo systemctl enable mariadb
```

2. Configure firewall for Database

```
sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
sudo firewall-cmd --reload
```

3. Configure Database

```
$ mysql
MariaDB > CREATE DATABASE ecomdb;
MariaDB > CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
MariaDB > GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost';
MariaDB > FLUSH PRIVILEGES;
```

> 💡 ON a multi-node setup remember to provide the IP address of the web server here: `'ecomuser'@'web-server-ip'`

4. Load Product Inventory Information to database

Create the db-load-script.sql

```
cat > db-load-script.sql <<-EOF
USE ecomdb;
CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;

INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");

EOF
```

Run sql script

```

sudo mysql < db-load-script.sql
```


## 🌍 Deploy and Configure Web

1. Install required packages

```
sudo yum install -y httpd php php-mysqlnd
sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --reload
```

2. Configure httpd

Change `DirectoryIndex index.html` to `DirectoryIndex index.php` to make the php page the default page

```
sudo sed -i 's/index.html/index.php/g' /etc/httpd/conf/httpd.conf
```

3. Start httpd

```
sudo systemctl start httpd
sudo systemctl enable httpd
```

4. Download code

```
sudo yum install -y git
sudo git clone https://github.com/ibn3bbas-sd/E-Commerce-Application-Project.git /var/www/html/
```

5. Update index.php
<!--

Update [index.php](https://github.com/ibn3bbas-sd/E-Commerce-Application-Project/blob/217838255a062a701816fab952cf794c5bde1dc1/index.php) file to connect to the right database server. In this case `localhost` since the database is on the same server.

```
sudo sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php

              <?php
                        $link = mysqli_connect('172.20.1.101', 'ecomuser', 'ecompassword', 'ecomdb');
                        if ($link) {
                        $res = mysqli_query($link, "select * from products;");
                        while ($row = mysqli_fetch_assoc($res)) { ?>
```

> ON a multi-node setup remember to provide the IP address of the database server here.
```
sudo sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php
```
-->

5. Create and Configure the `.env` File

   Create an `.env` file in the root of your project folder.

   ```sh
   cat > /var/www/html/.env <<-EOF
   DB_HOST=localhost
   DB_USER=ecomuser
   DB_PASSWORD=ecompassword
   DB_NAME=ecomdb
   EOF

6. Update `index.php`

   Update the `index.php` file to load the environment variables from the `.env` file and use them to connect to the database.

   ```php
   <?php
   // Function to load environment variables from a .env file
   function loadEnv($path)
   {
       if (!file_exists($path)) {
           return false;
       }

       $lines = file($path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
       foreach ($lines as $line) {
           if (strpos(trim($line), '#') === 0) {
               continue;
           }

           list($name, $value) = explode('=', $line, 2);
           $name = trim($name);
           $value = trim($value);
           putenv(sprintf('%s=%s', $name, $value));
       }
       return true;
   }

   // Load environment variables from .env file
   loadEnv(__DIR__ . '/.env');

   // Retrieve the database connection details from environment variables
   $dbHost = getenv('DB_HOST');
   $dbUser = getenv('DB_USER');
   $dbPassword = getenv('DB_PASSWORD');
   $dbName = getenv('DB_NAME');

   ?>

   💡 ON a multi-node setup, remember to provide the IP address of the database server in the .env file.


7. Test

```
curl http://localhost
```

## 📜 License

This project uses the [MIT License](./LICENSE).

---

## 🙋 Support

For issues, open a GitHub issue or reach out via email.

Let me know if you'd like:
- ⚡ A script to auto-install all components
- 📄 LICENSE file
- 🛑 .gitignore file
- 🤖 GitHub Actions workflow for automated deployment