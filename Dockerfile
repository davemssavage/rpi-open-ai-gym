FROM resin/rpi-raspbian

MAINTAINER David Savage <davemssavage@gmail.com>

# install pip3
RUN apt-get update -y && apt-get install -y ca-certificates && apt-get install -y python3-setuptools python3-dev build-essential

RUN easy_install3 pip

RUN apt-get install -y xauth git xvfb

WORKDIR /usr/src

RUN git clone git://git.videolan.org/x264 && cd x264 && ./configure --host=arm-unknown-linux-gnueabi --enable-static --disable-opencl && make &&  make install

RUN git clone https://github.com/FFmpeg/FFmpeg.git && cd FFmpeg && ./configure --arch=armel --target-os=linux --enable-gpl --enable-libx264 --enable-nonfree && make && make install

WORKDIR /home

RUN git clone https://github.com/openai/gym-http-api && cd gym-http-api && pip install -r requirements.txt

RUN rm -rf /var/lib/apt

EXPOSE 5000

CMD xvfb-run -s "-screen 0 1400x900x24" python3 -u gym-http-api/gym_http_server.py --listen 0.0.0.0
