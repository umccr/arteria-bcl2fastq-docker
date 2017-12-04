FROM python:2.7

ENV SERVICE_DIR="/opt/bcl2fastq-service"
ENV SERVICE_PORT=80
ENV CONF_DIR="$SERVICE_DIR/config/"

RUN mkdir -p $SERVICE_DIR
RUN git clone https://github.com/arteria-project/arteria-bcl2fastq.git $SERVICE_DIR


COPY app.config $CONF_DIR
RUN pip install -r $SERVICE_DIR/requirements/dev $SERVICE_DIR

EXPOSE $SERVICE_PORT
ENTRYPOINT ["sh", "-c", "exec bcl2fastq-ws --config $CONF_DIR --port $SERVICE_PORT"]
