FROM gitlab/gitlab-runner:latest
ARG REGISTRATION_TOKEN
# Install any necessary dependencies
RUN apt-get update && apt-get install -y curl jq

# Copy the custom executor scripts into the container
COPY config.sh /scripts/config.sh
COPY prepare.sh /scripts/prepare.sh
COPY run.sh /scripts/run.sh
COPY cleanup.sh /scripts/cleanup.sh
COPY somescript.sh /scritps/somescript.sh 
COPY config.toml /etc/gitlab-runner/config.toml

RUN chmod +x /scripts/*.sh

RUN sed -i "s/REPLACE_TOKEN/${REGISTRATION_TOKEN}/g" /etc/gitlab-runner/config.toml

# Environment variables for GitLab Runner registration
ENV CI_SERVER_URL=https://gitlab.com/
ENV REGISTRATION_TOKEN=${REGISTRATION_TOKEN}
ENV RUNNER_NAME=local-custom-runner
ENV RUNNER_EXECUTOR=custom
ENV RUNNER_TAG_LIST=local

# Register the runner without custom executor flags
RUN gitlab-runner register --non-interactive \
    --url $CI_SERVER_URL \
    --registration-token $REGISTRATION_TOKEN \
    --name $RUNNER_NAME \
    --executor "custom" 


# Start the GitLab Runner
CMD ["run"]
