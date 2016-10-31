FROM ruby:2.3

# Add user
RUN useradd -m -u 1000 user

run apt-get install -y imagemagick
run gem install rmagick
run gem install libroute-component

copy autoexec.rb  /home/user/autoexec.rb
run chown user:user /home/user/autoexec.rb
run chmod u+x /home/user/autoexec.rb

# Set user and entrypoint
USER user
ENTRYPOINT /home/user/autoexec.rb

