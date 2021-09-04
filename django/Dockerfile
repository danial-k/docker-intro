FROM python:3-slim

# Update and install OS dependencies as root
RUN apt-get update
RUN apt-get install -y \
    gcc \
    postgresql-server-dev-11

# Create non-root user
RUN adduser --group --system app

# Change to non root user for CMD and RUN commands
USER app

# Add the new users local python base to path
ENV PATH="/home/app/.local/bin:${PATH}"

# Update pip as user
RUN pip install --upgrade pip

# Change work directory
WORKDIR /app

# Copy requirements file first to leverage caching as app files change
COPY requirements.txt .

# Install application dependencies as non-root user
RUN pip install --user -r requirements.txt

# Copy remaining application files with user permissions
COPY . .

# Start gunicorn wsgi server and listen on all interfaces
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app.wsgi"]
