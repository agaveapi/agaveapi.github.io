FROM ruby:2.1-onbuild

EXPOSE 4567
CMD ["bundle", "exec", "middleman", "server"]