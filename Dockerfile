FROM jolielang/jolie

EXPOSE 8080

RUN wget https://jdbc.postgresql.org/download/postgresql-42.7.3.jar && \
    mv postgresql-42.7.3.jar /usr/lib/jolie/lib/jdbc-postgresql.jar

COPY rent.iol .
COPY server.ol .

CMD jolie --params /etc/data/config.json server.ol
