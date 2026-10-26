---
name: upgrade-go-fullnode
description: Upgrade a Golang fullnode (files using buildGoModule) to a new version for a FULLNODE Jira ticket — check master's version, branch, bump nix/gitlab config, fix src/vendor hashes, build locally, commit and push. Use when the user says things like "Update Geth to 1.17.9 FULLNODE-1234".
argument-hint: "<node> <x.y.z> FULLNODE-NNNN"
---

# Upgrade a Golang fullnode

Input: a node name, a target version `x.y.z`, and a Jira key `FULLNODE-NNNN` (e.g. "Update Geth to 1.17.9 FULLNODE-1234"). If any of the three is missing, ask.

Shell note: SCM Breeze is installed — never use heredocs; use `/bin/cat`, `/bin/rm`, `/bin/ls`, `/bin/mv`; commit with `-m` flags.

## 1. Check whether an update is needed

```shell
git fetch origin master
git show origin/master:fullnodes/<node>/flake.nix | grep 'version ='
```

- Map the node name to its directory under `fullnodes/` (lowercase, e.g. Geth → `geth`). If ambiguous, `ls fullnodes/` and ask.
- Confirm it's a Go node: the current `<node>-<version>.nix` contains `buildGoModule`. If not, stop and tell the user this skill only covers Go nodes.
- If master's version is already `>=` the requested version, stop and report — no changes.

## 2. Create the branch

Ensure the working tree is clean (`git status --porcelain`), otherwise stop and ask.

```shell
git checkout -b FULLNODE-NNNN origin/master
```

If the branch already exists, ask before reusing it.

## 3. Update the config

Let `OLD` = current version, `NEW` = target version. Convention: keep the previous version's file, delete any older ones.

1. Copy the current derivation: `/bin/cp fullnodes/<node>/<node>-OLD.nix fullnodes/<node>/<node>-NEW.nix`
2. Remove any `<node>-*.nix` file other than `OLD` and `NEW` (`git rm`).
3. In `<node>-NEW.nix`: set `version = "NEW";`. If `rev` is pinned to a commit rather than `v${version}`, ask the user for the correct rev/tag.
4. In `fullnodes/<node>/flake.nix`: set `version = "NEW";`. Check upstream's `go.mod` `go` directive for the new tag; if it requires a newer Go than the `buildGoXXXModule` in `vars`, bump it (verify the attribute exists in nixpkgs).
5. In `fullnodes/<node>/.gitlab-ci.yml`: replace every `VERSION: "OLD_WITH_UNDERSCORES"` with `VERSION: "NEW_WITH_UNDERSCORES"` (e.g. `1_17_9`).
6. `git add fullnodes/<node>` — nix flakes ignore untracked files.

## 4. Update hashes

Source hash — prefetch it (use the `owner`/`repo`/`rev` from the derivation):

```shell
nix-shell -p nix-prefetch-git --run "nix-prefetch-git --rev vNEW --url https://github.com/<owner>/<repo>" 2>/dev/null | grep '"hash"'
```

Put that SRI value in `src.hash`. (If the derivation uses `fetchurl`/release tarballs instead, use `nix store prefetch-file <url>`.)

Vendor hash — cannot be precomputed. Set `vendorHash = "";` (or `lib.fakeHash` style placeholder), then build:

```shell
nix -L build ./fullnodes/<node>#<node>-NEW_WITH_UNDERSCORES 2>&1 | tail -40
```

The failure prints `specified: ... got: sha256-...`. Put the `got:` value into `vendorHash`, `git add`, and rebuild. Do the same if the source hash mismatches. The build is long — run it in the background and wait for the notification.

## 5. Build

```shell
nix -L build ./fullnodes/<node>#<node>-NEW_WITH_UNDERSCORES
```

If it fails for a reason other than a hash mismatch (Go version, new subPackages, build tags, patches), investigate and fix; if the fix is non-trivial, stop and report to the user with the error rather than guessing. Do not commit a failing build.

## 6. Verify the binary version

Run the built binary (`/bin/ls result/bin/` to find it; it's usually the `Entrypoint` in `flake.nix`) and check it reports `NEW`:

```shell
./result/bin/<binary> version || ./result/bin/<binary> --version
```

The flag varies by node (`version`, `--version`, `-v`); check `--help` if neither works. If the output shows a different version, `0.0.0`, `dev`, or `unknown`, stop and report — the wrong tag was fetched or version ldflags are missing from the derivation. Don't commit until the version matches.

Remove the `result` symlink afterwards.

## 7. Commit and push

Match the repo's existing style (see `git log`):

```shell
git add fullnodes/<node>
git commit -m "Resolve FULLNODE-NNNN \"Upgrade <node> to vNEW\"" -m "Upgrade <node> to vNEW" -m "Closes FULLNODE-NNNN" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
git push -u origin FULLNODE-NNNN
```

Report: old → new version, hashes changed, Go toolchain change (if any), and the push result / MR link printed by GitLab.
