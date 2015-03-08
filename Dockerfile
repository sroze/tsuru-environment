FROM jpetazzo/dind

# Add Tsuru and its dependencies repositories
RUN apt-get update
RUN apt-get install -y curl software-properties-common python-software-properties

## Tsuru
RUN apt-add-repository ppa:tsuru/ppa -y

## MongoDB
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list

RUN apt-get update

# Install dependencies
RUN apt-get install -y mongodb-org redis-server
COPY ./etc/init.d/mongod /etc/init.d/mongod
RUN chmod +x /etc/init.d/mongod

# Install SSH server needed by Gandalf
RUN apt-get install -y openssh-server

# Install gandalf server
RUN apt-get install -y gandalf-server archive-server
RUN mkdir -p /home/git/bare-template/hooks
RUN curl https://raw.githubusercontent.com/tsuru/tsuru/master/misc/git-hooks/pre-receive.archive-server -o /home/git/bare-template/hooks/pre-receive
RUN chmod +x /home/git/bare-template/hooks/pre-receive
RUN chown -R git:git /home/git/bare-template
COPY ./git/.bash_profile /home/git/.bash_profile
COPY ./etc/gandalf.conf /etc/gandalf.conf

# Install Hipache router
RUN apt-get install -y node-hipache
COPY ./etc/hipache.conf /etc/hipache.conf

# Install Tsuru API and client
RUN apt-get install tsuru-server tsuru-admin tsuru-client -qqy
COPY ./etc/default/tsuru-server /etc/default/tsuru-server
COPY ./etc/tsuru/tsuru.conf /etc/tsuru/tsuru.conf

# Add startup scripts
COPY ./start.sh /start.sh
COPY ./configure.sh /configure.sh
RUN chmod +x /start.sh /configure.sh

# Expose ports
# Tsuru API
EXPOSE 8080
# SSH server
EXPOSE 22
# Gandalf
EXPOSE 8000
# Hipache Router
EXPOSE 80

ENTRYPOINT ["/start.sh"]

