-- Create additional databases for different environments
CREATE DATABASE IF NOT EXISTS myapp_development;
CREATE DATABASE IF NOT EXISTS myapp_test;
CREATE DATABASE IF NOT EXISTS myapp_production;
CREATE DATABASE IF NOT EXISTS myapp_production_cache;
CREATE DATABASE IF NOT EXISTS myapp_production_queue;
CREATE DATABASE IF NOT EXISTS myapp_production_cable;

-- Grant permissions to the rails user
GRANT ALL PRIVILEGES ON myapp_development.* TO 'rails'@'%';
GRANT ALL PRIVILEGES ON myapp_test.* TO 'rails'@'%';
GRANT ALL PRIVILEGES ON myapp_production.* TO 'rails'@'%';
GRANT ALL PRIVILEGES ON myapp_production_cache.* TO 'rails'@'%';
GRANT ALL PRIVILEGES ON myapp_production_queue.* TO 'rails'@'%';
GRANT ALL PRIVILEGES ON myapp_production_cable.* TO 'rails'@'%';

FLUSH PRIVILEGES;