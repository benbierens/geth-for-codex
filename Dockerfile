FROM ethereum/client-go:v1.11.5
RUN  apk --update add curl
COPY content .
ENTRYPOINT ["/usr/bin/env"]
CMD ["sh", "run.sh"]
