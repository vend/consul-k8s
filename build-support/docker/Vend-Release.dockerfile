FROM golang:1.11.0 as builder
ARG GIT_COMMIT
ARG GIT_DIRTY
ARG GIT_DESCRIBE
ENV CONSUL_DEV=1
ENV COLORIZE=0
Add / /opt/build
WORKDIR /opt/build
RUN make

FROM alpine:3.8

# Name is the name of the software
ARG NAME

# Copy binary from build container
COPY --from=builder /opt/build/bin/consul-k8s /bin

# Create a non-root user to run the software.
RUN addgroup ${NAME} && \
    adduser -S -G ${NAME} ${NAME}

    # Set up certificates, base tools, and software.
RUN set -eux && \
    apk add --no-cache ca-certificates curl su-exec iputils

USER ${NAME}
CMD /bin/${NAME}
