#!/bin/bash
set -e

if [[ "$1" == "lncli" ||"$1" == "lnd" ]]; then
	mkdir -p "$LND_DATA"

	CONFIG_PREFIX=""
	if [[ "${BITCOIN_NETWORK}" == "regtest" ]]; then
		CONFIG_PREFIX=$'regtest=1\n[regtest]'
	fi
	if [[ "${BITCOIN_NETWORK}" == "testnet" ]]; then
		CONFIG_PREFIX=$'testnet=1\n[test]'
	fi
	if [[ "${BITCOIN_NETWORK}" == "mainnet" ]]; then
		CONFIG_PREFIX=$'mainnet=1\n[main]'
	fi

	cat <<-EOF > "$LND_DATA/lnd.conf"
	${CONFIG_PREFIX}
	${BITCOIN_EXTRA_ARGS}
	EOF
	chown bitcoin:bitcoin "$LND_DATA/lnd.conf"

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R bitcoin "$LND_DATA"
	ln -sfn "$LND_DATA" /home/bitcoin/.lnd
	chown -h bitcoin:bitcoin /home/bitcoin/.lnd

	exec gosu bitcoin "$@"
else
	exec "$@"
fi
