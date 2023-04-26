## How to generate a patch file for our Lighthouse changes?

Just replace the branch names with the ones you want to create a patch for:

```
git diff v4.1.0..v4.1.0-modified -- . ':(exclude)Dockerfile' ':(exclude).gitlab-ci.yml' > 4.1.0-coinmetrics.patch
```
