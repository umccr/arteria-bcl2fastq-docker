FROM centos:7

RUN yum update -y \
    && yum install -y wget unzip git python-devel \
    && yum groupinstall -y "Development Tools"

##### install pip
RUN cd /tmp \
    && wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum install -y epel-release-latest-7.noarch.rpm \
    && yum install -y python-pip
RUN pip install --upgrade pip


##### get and install bcl2fastq
RUN cd /tmp \
    && wget https://support.illumina.com/content/dam/illumina-support/documents/downloads/software/bcl2fastq/bcl2fastq2-v2-20-0-linux-x86-64.zip 2>/dev/null \
    && unzip bcl2fastq2-v2-20-0-linux-x86-64.zip \
    && yum install -y bcl2fastq2-v2.20.0.422-Linux-x86_64.rpm
RUN rm /tmp/bcl2fastq2*


##### get and setup arteria bcl2fastq-ws
ENV SERVICE_DIR="/opt/bcl2fastq-service"
ENV SERVICE_PORT=80
ENV CONF_DIR="$SERVICE_DIR/config/"

RUN mkdir -p $SERVICE_DIR \
    && git clone https://github.com/umccr/arteria-bcl2fastq.git $SERVICE_DIR

COPY app.config $CONF_DIR
RUN pip install -r $SERVICE_DIR/requirements/dev $SERVICE_DIR

EXPOSE $SERVICE_PORT
ENTRYPOINT ["sh", "-c", "exec bcl2fastq-ws --config $CONF_DIR --port $SERVICE_PORT"]
