CREATE DATABASE opencart;
CREATE USER 'oc_user'@'localhost' IDENTIFIED BY 'StrongPassword!';
GRANT ALL PRIVILEGES ON opencart.* TO 'oc_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;