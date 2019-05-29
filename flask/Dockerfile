# Docker image for building a sample Flask Python app
# running on the gunicorn WSGI web server
FROM python:3.7
# Set working directory
WORKDIR /app
# Install dependencies
RUN pip install gunicorn flask
# Copy source files excluding those specified in build context
COPY app .
# Set command to run on start
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "wsgi"]
# Make external port available
EXPOSE 5000
