# 🛒 E-Commerce Application Setup (LAMP Stack on CentOS)

This guide provides step-by-step instructions to set up a PHP-based e-commerce application using **CentOS**, **Apache**, **MariaDB**, and **PHP** (LAMP stack). 

The **LAMP stack** is a popular open-source software stack used for web development. It consists of four key components:

- 🐧 **Linux**: The operating system that serves as the foundation.
- 🌐 **Apache**: A widely used web server that handles HTTP requests.
- 🐬 **MariaDB**: A relational database management system for storing and managing data.
- 🐘 **PHP**: The programming language used for dynamic content and backend logic.

---

## 📦 Tech Stack

- **OS**: CentOS
- **Web Server**: Apache (httpd)
- **Database**: MariaDB
- **Server-Side Language**: PHP

---

## ⚙️ Deploy Pre-Requisites

1. Install FirewallD:

   ```bash
   sudo yum install -y firewalld
   sudo systemctl start firewalld
   sudo systemctl enable firewalld
   sudo systemctl status firewalld
````

---

## 🛠️ Deploy and Configure Database

1. **Install MariaDB**:

   ```bash
   sudo yum install -y mariadb-server
   sudo vi /etc/my.cnf
   sudo systemctl start mariadb
   sudo systemctl enable mariadb
   ```

2. **Configure Firewall for MariaDB**:

   ```bash
   sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
   sudo firewall-cmd --reload
   ```

3. **Create and Configure Database**:

   ```sql
   $ mysql
   MariaDB > CREATE DATABASE ecomdb;
   MariaDB > CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
   MariaDB > GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost';
   MariaDB > FLUSH PRIVILEGES;
   ```

   > 💡 On a multi-node setup, replace `'localhost'` with `'web-server-ip'`.

4. **Load Product Inventory to Database**:
   Create the SQL script:

   ```bash
   cat > db-load-script.sql <<-EOF
   USE ecomdb;
   CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;

   INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");
   EOF
   ```

   Load the data:

   ```bash
   sudo mysql < db-load-script.sql
   ```

---

## 🌍 Deploy and Configure Web Server

1. **Install Required Packages**:

   ```bash
   sudo yum install -y httpd php php-mysqlnd
   sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
   sudo firewall-cmd --reload
   ```

2. **Configure Apache**:
   Set default document to PHP:

   ```bash
   sudo sed -i 's/index.html/index.php/g' /etc/httpd/conf/httpd.conf
   ```

3. **Start Apache**:

   ```bash
   sudo systemctl start httpd
   sudo systemctl enable httpd
   ```

4. **Clone Application Code**:

   ```bash
   sudo yum install -y git
   sudo git clone https://github.com/ibn3bbas-sd/E-Commerce-Application-Project.git /var/www/html/
   ```

5. **Configure Environment Variables**:
   Create `.env` file:

   ```bash
   cat > /var/www/html/.env <<-EOF
   DB_HOST=localhost
   DB_USER=ecomuser
   DB_PASSWORD=ecompassword
   DB_NAME=ecomdb
   EOF
   ```

6. **Update `index.php` to Use `.env`**:

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
           putenv(trim($name) . '=' . trim($value));
       }
       return true;
   }

   loadEnv(__DIR__ . '/.env');

   $dbHost = getenv('DB_HOST');
   $dbUser = getenv('DB_USER');
   $dbPassword = getenv('DB_PASSWORD');
   $dbName = getenv('DB_NAME');

   // Database connection here...
   ?>
   ```

   > 💡 On a multi-node setup, update `DB_HOST` in `.env` to point to the DB server IP.

7. **Test the Setup**:

   ```bash
   curl http://localhost
   ```

---

## 📜 License

This project uses the [MIT License](./LICENSE).

---

## 🙋 Support

For issues, open a GitHub issue or reach out via email.

Let me know if you'd like:

* ⚡ A script to auto-install all components
* 📄 `LICENSE` file
* 🛑 `.gitignore` file
* 🤖 GitHub Actions workflow for automated deployment

```

Let me know if you'd like me to generate the `.gitignore`, GitHub Actions workflow, or install script as well.
```
