# abhishekkar.info

A Jekyll site that GitHub Pages builds on every push to `master`. There is no build
step to run yourself: edit a data file, push, and the site updates in a minute or two.

## Where things live

| To change…                  | Edit                        |
|-----------------------------|-----------------------------|
| Headline, bio, contact links | `_data/profile.yml`         |
| Shipped products & features | `_data/shipped.yml`         |
| Papers                      | `_data/publications.yml`    |
| Career timeline             | `_data/experience.yml`      |
| Honors & teaching           | `_data/honors.yml`          |
| Page structure              | `index.html`, `_includes/`  |
| Look and feel               | `assets/css/site.css`       |

## Add a paper

Copy an entry to the top of `_data/publications.yml`:

```yaml
- id: my-paper-2027            # unique, used as the page anchor
  title: "My Paper Title"
  authors: "First Author, Abhishek Kar, Last Author"   # your name is bolded automatically
  venue: "CVPR"
  year: 2027
  award: "Oral"                # optional badge
  selected: true               # optional: also show it under "Selected research"
  image: assets/img/pubs/my-paper.jpg
  video: assets/img/pubs/my-paper.mp4   # optional looping teaser; image becomes its poster
  url: "https://project-page"  # the title links here
  links:
    - { label: "arXiv", url: "https://arxiv.org/abs/..." }
    - { label: "code", url: "https://github.com/..." }
  abstract: |-
    One paragraph.
  bibtex: |-
    @inproceedings{...}
```

Thumbnails are shown at 4:3. Keep videos small (a few MB at most).

## Add shipped work

Add an entry to `_data/shipped.yml` with `title`, `org`, `year`, `summary`, and
optionally `link`, `image` and `video`. Cards without an image show a plain tile.

## Preview

On the mini PC (Docker, no Ruby needed), from any device on Tailscale:

```sh
./preview.sh start   # http://100.93.187.103:8124/site/ — rebuilds when you save; refresh to see it
./preview.sh stop
```

It serves whatever branch the clone is on. Elsewhere: `bundle install && bundle exec jekyll serve`.

Older project pages (`categoryShapes/`, `lsm/`, `muse-whoop-privacy/`) and the
original paper assets stay at their old URLs.
