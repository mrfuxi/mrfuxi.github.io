FROM jekyll/jekyll:stable

RUN sudo apt-get update && sudo apt-get install -y -qq bundler
ADD Gemfile Gemfile

RUN sudo apt-get install -y -qq zlib1g-dev

RUN bundle install
# RUN sudo gem install github-pages

ENV EXECJS_RUNTIME Node
RUN sudo apt-get install -y -qq nodejs

VOLUME /srv/jekyll
CMD jekyll serve
