FROM grammatech/ddisasm
ENV DEBIAN_FRONTEND=noninteractive 
RUN apt-get update && apt-get install -y python3.9 python3-pip
RUN python3.9 -m pip install gtirb gtirb-rewriting
CMD ["/bin/bash"]

