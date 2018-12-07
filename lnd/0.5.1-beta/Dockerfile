FROM debian:stretch-slim

RUN groupadd -r bitcoin && useradd -r -m -g bitcoin bitcoin

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget \
	&& rm -rf /var/lib/apt/lists/*

ENV LND_VERSION 0.5.1-beta
ENV LND_URL https://github.com/lightningnetwork/lnd/releases/download/v0.5.1-beta/lnd-linux-amd64-v0.5.1-beta.tar.gz
ENV LND_SHA256 41bff3deda46777f498a23feb7feff331638bd0a745fac43ecff99179c701675
ENV LND_MANIFEST_URL https://github.com/lightningnetwork/lnd/releases/download/v0.5.1-beta/manifest-v0.5.1-beta.txt
ENV LND_MANIFEST_SIG_URL https://github.com/lightningnetwork/lnd/releases/download/v0.5.1-beta/manifest-v0.5.1-beta.txt.sig
ENV LND_SIG_URL https://github.com/lightningnetwork/lnd/releases/download/v0.5.1-beta/manifest-v0.5.1-beta.txt.sig.halseth
# ENV LND_PGP_KEY 7AB3D7F5911708842796513415BAADA29DA20D26

# install lnd binaries
RUN set -ex \
	&& cd /tmp \
	&& wget -qO lnd.tar.gz "$LND_URL" \
	&& echo "$LND_URL downloaded" \
	&& echo "$LND_SHA256 lnd.tar.gz" | sha256sum -c - \
	&& echo "$LND_SHA256 checksum ok" \
	&& wget -q -O - https://keybase.io/roasbeef/pgp_keys.asc | gpg --import \
	&& wget -q -O - https://keybase.io/halseth/pgp_keys.asc | gpg --import \
	&& wget -qO manifest-v0.5.1-beta.txt "$LND_MANIFEST_URL" \
	&& wget -qO manifest-v0.5.1-beta.txt.sig "$LND_MANIFEST_SIG_URL" \
	&& wget -qO manifest-v0.5.1-beta.txt.sig.halseth "$LND_SIG_URL" \
	&& gpg --verify manifest-v0.5.1-beta.txt.sig.halseth manifest-v0.5.1-beta.txt \
	&& echo "gpg signature checksum ok" \
	&& tar -xzvf lnd.tar.gz -C /usr/local/bin --strip-components=1 --exclude=*-qt \
	&& rm -rf /tmp/*

# create data directory
ENV LND_DATA /data
RUN mkdir "$LND_DATA" \
	&& chown -R bitcoin:bitcoin "$LND_DATA" \
	&& ln -sfn "$LND_DATA" /home/bitcoin/.lnd \
	&& chown -h bitcoin:bitcoin /home/bitcoin/.lnd
VOLUME /data

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8332 8333 18332 18333 18443 18444
CMD ["lnd"]
