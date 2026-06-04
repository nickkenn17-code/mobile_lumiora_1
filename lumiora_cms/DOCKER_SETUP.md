# Docker Setup Guide for Lumiora CMS

## Prerequisites

- Docker Desktop installed (https://www.docker.com/products/docker-desktop)
- Docker Compose (comes with Docker Desktop)

## Quick Start

### 1. Build the Docker Image

```bash
cd lumiora_cms
docker-compose build
```

### 2. Start the Application

```bash
docker-compose up -d
```

This will:
- ✅ Start the Django CMS on http://localhost:8000
- ✅ Start PostgreSQL database on localhost:5432
- ✅ Start Nginx reverse proxy on http://localhost
- ✅ Create and run all migrations automatically

### 3. Access the Application

- **Admin Dashboard:** http://localhost/admin/
- **API:** http://localhost/api/
- **Direct Django:** http://localhost:8000

### 4. Create a Superuser

```bash
docker-compose exec web python manage.py createsuperuser
```

Follow the prompts to create your admin account.

### 5. View Logs

```bash
# View all services
docker-compose logs -f

# View only web service
docker-compose logs -f web

# View only database
docker-compose logs -f db
```

## Common Commands

### Stop the Application

```bash
docker-compose down
```

### Stop and Remove Volumes (Delete database)

```bash
docker-compose down -v
```

### Restart Services

```bash
docker-compose restart
```

### Run Django Management Commands

```bash
# Create migrations
docker-compose exec web python manage.py makemigrations

# Apply migrations
docker-compose exec web python manage.py migrate

# Collect static files
docker-compose exec web python manage.py collectstatic

# Shell
docker-compose exec web python manage.py shell

# Create superuser
docker-compose exec web python manage.py createsuperuser
```

### Access Database

```bash
# Connect to PostgreSQL
docker-compose exec db psql -U lumiora_user -d lumiora_db

# Backup database
docker-compose exec db pg_dump -U lumiora_user -d lumiora_db > backup.sql

# Restore database
docker-compose exec -T db psql -U lumiora_user -d lumiora_db < backup.sql
```

## Services

### Web Service (Django)
- **Port:** 8000 (internal), 80 (nginx)
- **Environment:** Python 3.12, Gunicorn
- **Database:** PostgreSQL

### Database Service (PostgreSQL)
- **Port:** 5432
- **Username:** lumiora_user
- **Password:** lumiora_secure_password_123 (change in production!)
- **Database:** lumiora_db

### Nginx Service
- **Port:** 80 (HTTP), 443 (HTTPS)
- **Role:** Reverse proxy, static files serving

## Production Deployment

### 1. Update Environment Variables

Edit `.env.docker`:
```
DEBUG=False
SECRET_KEY=your-actual-secret-key-here
ALLOWED_HOSTS=yourdomain.com,www.yourdomain.com
DB_PASSWORD=change-to-strong-password
```

### 2. Use Production Settings

For production, consider:
- Using a real SECRET_KEY (generate one: `python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'`)
- Setting DEBUG=False
- Using environment-specific database backups
- Setting up SSL/HTTPS with certificates
- Using external PostgreSQL service (AWS RDS, etc.)

### 3. Deploy to Server

```bash
# Clone repository
git clone your-repo-url
cd lumiora_cms

# Set production environment
cp .env.docker .env.production
# Edit .env.production with production values

# Build and run
docker-compose -f docker-compose.yml up -d
```

## Troubleshooting

### Port Already in Use

If port 8000, 80, or 5432 is already in use:

Edit `docker-compose.yml` and change the ports:
```yaml
ports:
  - "8001:8000"  # Use 8001 instead
```

### Database Connection Error

Wait a few seconds for PostgreSQL to be ready. The service has a health check.

### Migrations Not Running

```bash
docker-compose exec web python manage.py migrate
```

### Permission Denied Errors

On Linux, you might need to run with sudo or add your user to the docker group:
```bash
sudo usermod -aG docker $USER
```

Then restart Docker:
```bash
sudo systemctl restart docker
```

### View Resource Usage

```bash
docker stats
```

## Updating the Application

```bash
# Pull latest code
git pull

# Rebuild image
docker-compose build --no-cache

# Restart services
docker-compose down
docker-compose up -d

# Run migrations
docker-compose exec web python manage.py migrate
```

## Backing Up Database

```bash
# Create backup
docker-compose exec db pg_dump -U lumiora_user -d lumiora_db > lumiora_backup_$(date +%Y%m%d_%H%M%S).sql

# List backups
ls -lh *.sql
```

## Accessing from Mobile App

To connect your Flutter mobile app to the dockerized CMS:

**Development (on same machine):**
```
http://localhost:8000/api/
```

**From another machine:**
```
http://<your-machine-ip>:8000/api/
```

**On Docker network:**
```
http://web:8000/api/
```

## Performance Tips

1. **Use .env for sensitive data** - Never commit secrets
2. **Set resource limits** in docker-compose.yml if needed
3. **Use production database** like AWS RDS for reliability
4. **Enable caching** for static files
5. **Monitor logs** regularly
6. **Backup database** regularly

## Support & Documentation

- Django: https://docs.djangoproject.com/
- Docker: https://docs.docker.com/
- Docker Compose: https://docs.docker.com/compose/
- PostgreSQL: https://www.postgresql.org/docs/

---

**Status:** Ready for production deployment ✅
