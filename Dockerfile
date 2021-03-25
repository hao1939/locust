FROM python:3.8

# extra dependencies (over what buildpack-deps already includes)
RUN apt-get update && apt-get install -y --no-install-recommends \
		sudo \
		net-tools \
		vim \
	&& rm -rf /var/lib/apt/lists/*

RUN echo "locust ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user

COPY . /build
RUN cd /build && pip install . && rm -rf /build
RUN pip install locust-plugins

EXPOSE 8089 5557

RUN useradd --create-home locust
USER locust
WORKDIR /home/locust
ENTRYPOINT ["locust"]

# turn off python output buffering
ENV PYTHONUNBUFFERED=1
