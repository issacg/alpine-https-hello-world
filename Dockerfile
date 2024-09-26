FROM alpine

COPY --chmod=0755 install.sh /install.sh
CMD [ "/install.sh" ]