FROM python:3.12-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        flac \
        build-essential \
        python3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
        "git+https://github.com/BruiserBrody17/beets.git@fix-fetchart-nested-art-dirs" \
        "git+https://github.com/BruiserBrody17/beets-originquery.git" \
        "git+https://github.com/BruiserBrody17/beets-classical-tags.git" \
        "git+https://github.com/BruiserBrody17/beets-roon-artwork.git"

ENV BEETSDIR=/config

VOLUME ["/config", "/music/incoming", "/music/library"]

CMD ["sleep", "infinity"]
