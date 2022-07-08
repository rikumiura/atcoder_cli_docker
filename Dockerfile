# Ubuntuの公式コンテナを軸に環境構築
FROM ubuntu

# インタラクティブモードにならないようにする
ARG DEBIAN_FRONTEND=noninteractive
# タイムゾーンを日本に設定
ENV TZ=Asia/Tokyo

# インフラを整備
RUN apt-get update && \
        apt-get install -y zsh time tzdata tree git curl

# デフォルトシェルをZ shellにする
RUN chsh -s /bin/zsh

# zshrcをコピー
COPY ./.zshrc home/.zshrc

# zshrcを更新
RUN ["/bin/zsh", "-c", "source /home/.zshrc"]

# C++, Python3, PyPy3の3つの環境想定
RUN apt-get update && \
        apt-get install -y gcc-9 g++-9 python3 python3-pip pypy3 nodejs npm

# 一般的なコマンドで使えるように設定
# e.g. python3.8 main.py => python main.py
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 30 && \
        update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 30 && \
        update-alternatives --install /usr/bin/python python /usr/bin/python3 30 && \
        update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 30 && \
        update-alternatives --install /usr/bin/pypy pypy /usr/bin/pypy3 30 && \
        update-alternatives --install /usr/bin/node node /usr/bin/nodejs 30

# AtCoderでも使えるPythonライブラリをインストール
RUN pip install numpy && \
        pip install scipy && \
        pip install scikit-learn && \
        pip install numba && \
        pip install networkx

# C++でAtCoder Library(ACL)を使えるようにする
RUN git clone https://github.com/atcoder/ac-library.git /lib/ac-library
ENV CPLUS_INCLUDE_PATH /lib/ac-library

# Pythonでの競技プログラミング用データ構造をインストール
RUN pip install git+https://github.com/hinamimi/ac-library-python && \
        pip install git+https://github.com/hinamimi/python-sortedcontainers

# コンテスト補助アプリケーションをインストール
RUN pip install online-judge-tools
RUN npm install -g atcoder-cli

# atcoder-cliの設定
RUN acc config-dir && \
        acc config default-template python && \
        acc config default-test-dirname-format test

# # AHC用のRustのinstall
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH $PATH:/home/root/.cargo/bin

WORKDIR /root/problems
WORKDIR /root/library
