# Docker-Lightning

Quick and easy lightning-node setup based on LND / bitcoind

### Use-Case

You have already have a machine that does docker-compose and want a bitcoin lightning-node ASAP without hassle. This docker-compose environment spins up a bitcoind (pruned to 10GB) and starts a lnd lightning-node on top of it. Possibly the fastest way to get a flexible lnd-instance with full access to get started for developing for the lightning network.

### Usage

To start a bitcoind instance running the latest version:

```
$ docker-compose up
```
