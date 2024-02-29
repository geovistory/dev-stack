# Pulling ubuntu image with a specific tag from the docker hub.
FROM ubuntu:18.04

# Adding maintainer name (Optional).
MAINTAINER Jonas Schneider

# Updating the packages and installing cron and vim editor if you later want to edit your script from inside your container.
RUN apt-get update \  
&& apt-get install cron jq curl bsdmainutils -y

# Crontab file copied to cron.d directory.
COPY ./cronjob /etc/cron.d/container_cronjob

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/container_cronjob

# Apply cron job
RUN crontab /etc/cron.d/container_cronjob

# Copy the script
COPY ./script.sh /script.sh

# Give execution rights on the script
RUN chmod 0744 /script.sh

COPY ./init.sh /

# Run the command on container startup
# CMD cron && tail -f /var/log/cron.log
CMD ["bash", "/init.sh"]