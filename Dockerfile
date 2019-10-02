FROM scratch

ENV FAIL_PERCENTAGE=0

EXPOSE 8080 1234

WORKDIR /opt/randfail

ADD main /
CMD ["/main"]