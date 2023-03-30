FROM ethereum/client-go:v1.11.5
COPY passwordfile passwordfile
COPY run.sh run.sh
ENTRYPOINT ["/usr/bin/env"]
CMD ["sh", "run.sh"]
