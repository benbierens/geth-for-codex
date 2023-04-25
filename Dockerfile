FROM ethereum/client-go:v1.11.5
COPY content .
RUN apk add nodejs
RUN apk add zip
ENTRYPOINT ["/usr/bin/env"]
CMD ["sh", "run.sh"]
