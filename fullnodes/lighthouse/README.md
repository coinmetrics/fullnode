## How to update our Lighthouse node?

### Generating a Cargo.lock file

In the custom lighthouse repo, after having checked out the branch you want to build (vx.y.z-modified), run:

```
cargo generate-lockfile --offline
cp Cargo.lock /path/to/fullnode/fullnodes/lighthouse/x.y.z-Cargo.lock
```