# beets-unraid

Docker image + Unraid template for a custom beets build: the
`fix-fetchart-nested-art-dirs` branch of
[BruiserBrody17/beets](https://github.com/BruiserBrody17/beets), plus three
plugins:

- [beets-originquery](https://github.com/BruiserBrody17/beets-originquery) --
  reads `origin.yaml` per-album metadata to improve MusicBrainz matches, and
  prompts interactively when it and MusicBrainz disagree on the VERSION tag.
- [beets-classical-tags](https://github.com/BruiserBrody17/beets-classical-tags) --
  writes WORK/MOVEMENTNAME/MOVEMENTNUMBER/SHOWMOVEMENT tags.
- [beets-roon-artwork](https://github.com/BruiserBrody17/beets-roon-artwork) --
  strips embedded art, builds a folder-based `Artwork/` directory for Roon,
  and writes the VERSION tag.

The container has no web UI. It just stays running (`sleep infinity`); you
open its Console from the Unraid Docker tab (or `docker exec -it
beets-custom bash`) and run `beet import`, `beet list`, etc. by hand -- same
workflow used to develop this.

## Build on your Unraid box

SSH into Unraid (or use the built-in terminal), then:

```sh
git clone https://github.com/BruiserBrody17/beets-unraid.git
cd beets-unraid
docker build -t beets-custom:latest .
```

Re-run the `git clone`+`docker build` (or `git pull` + rebuild in an
existing checkout) any time you want to pick up new commits from any of the
four repos above -- the Dockerfile always pulls their current `HEAD`/branch
tip.

## Install the template

1. In the Unraid Docker tab, go to **Add Container**, switch to **Template
   repositories** view (or just paste this repo's raw `beets-custom.xml`
   URL into the "Template" field), or copy `beets-custom.xml` directly into
   `/boot/config/plugins/dockerMan/templates-user/` over SMB/SSH.
2. Set the three path mappings (Config / Incoming / Library) to match your
   actual folders -- the defaults in the template are placeholders.
3. Apply. The container will start and just sit idle.
4. Before importing anything, put a working `config.yaml` at the path you
   mapped to `/config` -- start from `config.yaml.example` in this repo and
   adjust `directory`/`library` if you didn't use the same container paths
   suggested here.
5. Open the container's Console (or `docker exec -it beets-custom bash`)
   and run beets normally, e.g.:

   ```sh
   beet import /music/incoming
   ```

## Notes

- `import.timid: yes` is on by default in `config.yaml.example` -- every
  match, even a 100% one, stops for manual confirmation. This isn't
  optional flourish: across development, beets' own auto-match picked the
  wrong release three separate times on releases that needed origin.yaml's
  catalog number to disambiguate. Turning it off restores silent
  auto-apply.
- `move: no` / `copy: yes` is the default (matches the sandboxed dev setup,
  where source and destination were different machines). On a single
  Unraid array you likely want `move: yes` / `copy: no` instead, once
  you've verified the pipeline, to avoid double storage.
- No auto-import/watch-folder behavior is set up -- this is intentionally
  manual for now.
