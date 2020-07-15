FROM golang:alpine3.11
LABEL maintainer="shibme"
RUN apk add --no-cache curl wget bash openssh-client git openjdk8 maven gradle ruby ruby-io-console ruby-bundler ruby-json
RUN gem install rdoc --no-document
RUN gem install bundler:1.17.1
RUN gem install bundler
RUN gem install brakeman
RUN gem install bundler-audit
RUN bundle-audit update
RUN apk add --no-cache npm
RUN npm install -g retire
WORKDIR /tools
ADD https://dl.bintray.com/jeremy-long/owasp/dependency-check-5.3.2-release.zip /tools/dependency-check.zip
RUN unzip dependency-check.zip
RUN rm dependency-check.zip
RUN ln -s /tools/dependency-check/bin/dependency-check.sh /bin/dependency-check
RUN go get github.com/securego/gosec/cmd/gosec
RUN ln -s /go/bin/gosec /bin/gosec
RUN mkdir -p /root/.ssh
RUN printf "Host *\n    StrictHostKeyChecking no" > /root/.ssh/config
RUN chmod 400 /root/.ssh/config
RUN dependency-check -s /tmp/ && rm dependency-check-report.html
RUN bundle audit update
RUN retire update
WORKDIR /codeinspect