FROM gitlab/gitlab-runner:latest

# Install any necessary dependencies
RUN apt-get update && apt-get install -y curl jq

# Copy the custom executor scripts into the container
COPY config.sh /scripts/config.sh
COPY prepare.sh /scripts/prepare.sh
COPY run.sh /scripts/run.sh
COPY cleanup.sh /scripts/cleanup.sh
COPY somescript.sh /scritps/somescript.sh 
COPY config.toml /etc/gitlab-runner/config.toml.template

RUN chmod +x /scripts/*.sh

COPY ./start.sh ./
RUN chmod +x /start.sh


# Environment variables for GitLab Runner registration
ENV CI_SERVER_URL=https://gitlab.com/
ENV REGISTRATION_TOKEN=glrt-XGzpimfDXuvSB55B4buU
ENV RUNNER_NAME=local-custom-runner
ENV RUNNER_EXECUTOR=custom
ENV RUNNER_TAG_LIST=local

# Register the runner without custom executor flags
RUN gitlab-runner register --non-interactive \
    --url $CI_SERVER_URL \
    --registration-token $REGISTRATION_TOKEN \
    --name $RUNNER_NAME \
    --executor "custom" 


ENTRYPOINT ["/start.sh"]    
# Start the GitLab Runner
CMD ["gitlab-runner", "run"]
