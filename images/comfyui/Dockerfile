FROM ocr.jcan.dev/dh/pytorch/pytorch:2.5.1-cuda12.4-cudnn9-runtime

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1

RUN apt-get update && apt-get install -y git libgoogle-perftools-dev && apt-get clean

ARG PUID=0
ARG PGID=0
ARG USER_HOME=/root
# set build args as container environment variables for entrypoint reference
ENV PUID=$PUID
ENV PGID=$PGID
ENV USER_HOME=$USER_HOME

# if user home does not exist, create it
RUN mkdir -p "$USER_HOME"

# home already exists, chown it
RUN chown -R "${PUID}:${PGID}" "$USER_HOME"

# Only groupadd if we're non root
RUN if [ "$PGID" -ne "0" ]; then \
      echo non root group detected; \
      groupadd \
        --gid "$PGID" \
        stablediffusion ;\
    else \
      echo "root group detected" ; \
    fi

# Only useradd if we're non root
RUN if [ "$PUID" -ne "0" ]; then \
      echo non root user detected; \
      useradd \
        --gid="$PGID" \
        --no-user-group \
        -M \
        --home "$USER_HOME" \
        stablediffusion ; \
    else \
      echo "root group detected" ; \
    fi

USER $PUID:$PGID

# Set reference directory
ENV ROOT=/stable-diffusion
COPY --chown=$PUID:$PGID . ${ROOT}

# Install comfyui dependencies
RUN --mount=type=cache,target="$USER_HOME"/.cache/pip \
  pip install -r ${ROOT}/resources/comfyui/requirements.txt

# Install comfyui-manager and its dependencies
RUN mv ${ROOT}/resources/comfyui-manager ${ROOT}/resources/comfyui/custom_nodes/comfyui-manager \
    && pip install -r ${ROOT}/resources/comfyui/custom_nodes/comfyui-manager/requirements.txt

RUN chown -R "$PUID:$PGID" "${ROOT}"
WORKDIR ${ROOT}/resources/comfyui
RUN chmod u+x ${ROOT}/images/comfyui/entrypoint.sh ${ROOT}/images/comfyui/synchronise_paths.sh

ENV NVIDIA_VISIBLE_DEVICES=all CLI_ARGS="" PORT=7860 HOST=0.0.0.0
EXPOSE ${PORT}
ENTRYPOINT ["/stable-diffusion/images/comfyui/entrypoint.sh"]
CMD ["sh", "-c", "python3 -c 'import os; print(f\"Running as UID={os.getuid()}, GID={os.getgid()}\")' && python -u main.py --listen ${HOST} --port ${PORT} ${CLI_ARGS}"]
