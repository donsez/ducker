FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    gettext-base \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install DuckDB
# --------------

# Place this after apt-get so it doesn't bust the cache
ARG DUCKDB_VERSION
ARG DUCKDB_ARCH

RUN wget https://github.com/duckdb/duckdb/releases/download/${DUCKDB_VERSION}/duckdb_cli-linux-${DUCKDB_ARCH}.zip \
    && unzip duckdb_cli-linux-${DUCKDB_ARCH}.zip -d /usr/local/bin \
    && rm duckdb_cli-linux-${DUCKDB_ARCH}.zip

# Create ~/.duckdbrc file
# -----------------------

RUN echo ".prompt '⚫◗ '" > $HOME/.duckdbrc
#RUN echo ".prompt '<ESC>[33m⚫◗<ESC>[37m '" > $HOME/.duckdbrc

# Install Extensions
# ------------------

ARG EXTENSIONS
ARG LOAD_EXTENSIONS

RUN for e in $EXTENSIONS; do \
    echo "Installing $e ..."; \
    duckdb -c "INSTALL $e;"; \
    echo "LOAD $e;" >> $HOME/.duckdbrc; \
    done

# Install PRQL
# ------------

ARG PRQL_VERSION

#RUN duckdb -unsigned -c "SET custom_extension_repository='welsch.lu/duckdb/prql/$PRQL_VERSION'; INSTALL prql;" \
#RUN duckdb -unsigned -c "SET custom_extension_repository='welsch.lu/duckdb/prql/$PRQL_VERSION/linux_${DUCKDB_ARCH}'; INSTALL prql;" \
#    && echo "LOAD prql;" >> $HOME/.duckdbrc
RUN echo "PRQL Extension is not installed !!!!!!!!!!!!"


# Add ducker.sh entrypoint
COPY ducker.sh /usr/local/bin/ducker

ENTRYPOINT ["/usr/local/bin/ducker", "-unsigned"]
#ENTRYPOINT ["/usr/local/bin/duckdb", "-unsigned"]
CMD []
