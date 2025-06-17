# 🛒 E-Commerce Application Setup (LAMP Stack on CentOS)

This guide provides step-by-step instructions to set up a PHP-based e-commerce application using **CentOS**, **Apache**, **MariaDB**, and **PHP** (LAMP stack). Ideal for hosting platforms like **OpenCart**, **Magento**, or **WooCommerce**.

---

## 📦 Tech Stack

- **OS**: CentOS 7/8
- **Web Server**: Apache (httpd)
- **Database**: MariaDB
- **Server-Side Language**: PHP 7.4+
- **Platform**: OpenCart (recommended)

---

## 📁 Directory Structure

```bash
/var/www/html/
├── opencart/                 # E-Commerce Platform
└── ecommerce-configs/
    ├── apache/
    │   └── opencart.conf     # Apache virtual host config
    ├── mysql/
    │   └── init.sql          # DB init script
    └── backup/
        ├── db-backup.sh
        └── files-backup.sh
```

---

## 🚀 Installation Steps

### 1. Update System

```bash
sudo yum update -y
```
### 2. Install Firewall

```bash
sudo yum install firewalld -y
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo systemctl status firewalld
```

### 3. Install MariaDB

```bash
sudo yum install mariadb-server -y
sudo systemctl enable --now mariadb
sudo service maridb start
sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
sudo firewall-cmd --reload
sudo mysql_secure_installation
```

### 4. Install Apache

```bash
sudo yum install httpd -y
sudo systemctl enable --now httpd
```

### 4. Install PHP

#### For CentOS 7

```bash
sudo yum install epel-release -y
sudo yum install yum-utils -y
sudo yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
sudo yum-config-manager --enable remi-php74
sudo yum install php php-mysql php-gd php-xml php-mbstring php-curl php-zip -y
```

#### For CentOS 8

```bash
sudo dnf module reset php
sudo dnf module enable php:7.4
sudo dnf install php php-mysqlnd php-gd php-xml php-mbstring php-curl php-zip -y
```

---

## 🌐 Web Server Setup

### Apache Configuration

Create a virtual host:

```bash
sudo nano /etc/httpd/conf.d/opencart.conf
```

```apache
<VirtualHost *:80>
    ServerName yourdomain.com
    DocumentRoot /var/www/html/opencart

    <Directory /var/www/html/opencart>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog /var/log/httpd/opencart_error.log
    CustomLog /var/log/httpd/opencart_access.log combined
</VirtualHost>
```

```bash
sudo systemctl restart httpd
```

---

## 🛠️ Deploy OpenCart

```bash
cd /tmp
wget https://github.com/opencart/opencart/releases/download/4.0.2.3/opencart-4.0.2.3.zip
sudo yum install unzip -y
unzip opencart-4.0.2.3.zip
sudo mv upload/ /var/www/html/opencart
sudo chown -R apache:apache /var/www/html/opencart
```

---

## 🗄️ Database Setup

```bash
mysql -u root -p
```

```sql
CREATE DATABASE opencart;
CREATE USER 'oc_user'@'localhost' IDENTIFIED BY 'StrongPassword!';
GRANT ALL PRIVILEGES ON opencart.* TO 'oc_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

```bash
mysql -u oc_user -p opencart < /path/to/opencart.sql
```
---

## 🔒 Optional: Enable SSL (Let's Encrypt)

```bash
sudo yum install epel-release -y
sudo yum install certbot python2-certbot-apache -y
sudo certbot --apache
```

---

## 🔍 Test Setup

* Apache: `http://your-server-ip/`
* PHP: `http://your-server-ip/info.php`
* OpenCart: `http://your-server-ip/opencart/install`

---

## 📌 Maintenance Tips

* Backup files and database regularly
* Use `fail2ban`, `firewalld`, and secure SSH
* Update packages monthly

---

## 🧪 Optional Tools

* phpMyAdmin

```bash
sudo yum install phpmyadmin -y
```

* Adminer (single PHP file DB admin)
* Git integration for version control

---

## 📜 License

This project uses the [MIT License](./LICENSE).

---

## 🙋 Support

For issues, open a GitHub issue or reach out via email.

```

---

Let me know if you'd like:
- A script to auto-install all components
- `LICENSE`
- `.gitignore`
- GitHub Actions workflow for automated deployment
```
# E-Commerce-Application
# E-Commerce-Application
# E-Commerce-Application-Project
