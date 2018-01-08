# for use with the update command
FROM ruby:2.5-stretch
RUN apt-get update && apt-get install python-pip -y
RUN pip install awscli --upgrade --user
# pip installs executables to /root/.local/bin which is not on our PATH by default:
ENV PATH="/root/.local/bin:${PATH}" 
