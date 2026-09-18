FROM python:3.12-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        flac \
        build-essential \
        python3-dev \
        gosu \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
        "git+https://github.com/BruiserBrody17/beets.git@fix-fetchart-nested-art-dirs" \
        "git+https://github.com/BruiserBrody17/beets-originquery.git" \
        "git+https://github.com/BruiserBrody17/beets-classical-tags.git" \
        "git+https://github.com/BruiserBrody17/beets-roon-artwork.git"

# Placeholder ids -- entrypoint.sh remaps these to PUID/PGID at container
# start (the -o flags let it collide with an existing id, e.g. Debian's
# own "users" group, without failing).
RUN groupadd -o -g 100 beets \
    && useradd -o -u 99 -g 100 -M -d /config -s /bin/bash beets

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV BEETSDIR=/config

VOLUME ["/config", "/music/incoming", "/music/library"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["sleep", "infinity"]
