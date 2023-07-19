## How to update our Lighthouse node?

1. Generate a patch file for the version you want to upgrade to:

Just replace the branch names with the ones you want to create a patch for:

```
git diff v4.1.0..v4.1.0-modified -- . ':(exclude)Dockerfile' ':(exclude).gitlab-ci.yml' > 4.1.0-coinmetrics.patch
```

Copy that file to `lighthouse/patches`

2. Generate an updated cargo lock file

In the custom lighthouse repo run:

```
git apply /path/to/fullnode/fullnodes/lighthouse/patches/use-system-sqlite.patch
cargo generate-lockfile --offline
cp Cargo.lock /path/to/fullnode/fullnodes/lighthouse/x.y.z-Cargo.lock
```

3. Create a nix file for that version by copying one of the existing one
4. Replace the hash in the fetchFromGitHub block of the nix file with a different one so that the Nix build outputs the expected one
5. Run the nix build command locally (if possible) to replace other hashes that may have changed

```
nix --extra-experimental-features nix-command --extra-experimental-features flakes --print-build-logs run .#publish-lighthouse -- dry-run
```